package uec.teehardware.devices.opentitan.hmac

import chisel3._
import chisel3.experimental._
import chisel3.util._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.devices.tilelink.{BasicBusBlockerParams, TLClockBlocker}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.diplomaticobjectmodel.DiplomaticObjectModelAddressing
import freechips.rocketchip.diplomaticobjectmodel.logicaltree.{LogicalModuleTree, LogicalTreeNode}
import freechips.rocketchip.diplomaticobjectmodel.model.{OMComponent, OMDevice, OMInterrupt, OMMemoryRegion}
import freechips.rocketchip.interrupts._
import freechips.rocketchip.prci.{ClockGroup, ClockSinkDomain}
import freechips.rocketchip.regmapper._
import freechips.rocketchip.subsystem.{Attachable, PBUS, TLBusWrapperLocation}
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util._
import uec.teehardware.devices.opentitan._
import uec.teehardware.devices.opentitan.alert._
import uec.teehardware.devices.opentitan.top_pkg._

import sys.process._

object hmac_reg_pkg {
  def NumWords = 8
  def NumAlerts = 1
}

case class HMACParams(address: BigInt)

case class OMHMACDevice
(
  memoryRegions: Seq[OMMemoryRegion],
  interrupts: Seq[OMInterrupt],
  _types: Seq[String] = Seq("OMHMACDevice", "OMDevice", "OMComponent")
) extends OMDevice

class HMACPortIO extends Bundle {
}

class hmac_wrapper
(
  AlertAsyncOn: Seq[Boolean] = Seq.fill(hmac_reg_pkg.NumAlerts)(true)
)
  extends BlackBox(
    Map(
      "AlertAsyncOn" -> RawParam( // Default: 1'b1
        hmac_reg_pkg.NumAlerts.toString + "'b" +
          AlertAsyncOn.map(if(_) "1" else "0").reduce((a,b) => b+a)
      )
    )
  )
    with HasBlackBoxResource {

  // The TLparams. Those are very specitic
  val TLparams = new TLBundleParameters(
    addressBits = TL_AW,
    dataBits = TL_DW,
    sourceBits = TL_AIW,
    sinkBits = TL_DIW,
    sizeBits = TL_SZW,
    echoFields = Seq(),
    requestFields = Seq(
      tl_a_user_t_ExtraField()
    ),
    responseFields = Seq(
      UIntExtraField(TL_DUW)
    ),
    hasBCE = false
  )

  val io = IO(new Bundle {
    // Clock and Reset
    val clk_i = Input(Clock())
    val rst_ni = Input(Bool())

    // Bus interface
    val tl = Flipped(new TLBundle(TLparams))

    // Interrupts
    val intr_hmac_done_o = Output(Bool())
    val intr_fifo_empty_o = Output(Bool())
    val intr_hmac_err_o = Output(Bool())

    // Alerts
    val alert_rx_i = Vec(hmac_reg_pkg.NumAlerts, Input(new alert_rx_t()))
    val alert_tx_o = Vec(hmac_reg_pkg.NumAlerts, Output(new alert_tx_t()))
  })

  // pre-process the verilog to remove "includes" and combine into one file
  val make = "make -C hardware/teehw/src/main/resources hmac"
  val proc = make
  require (proc.! == 0, "Failed to run preprocessing step")

  // add wrapper/blackbox after it is pre-processed
  addResource("/hmac.preprocessed.v")
}

class HMAC(blockBytes: Int, beatBytes: Int, params: HMACParams)(implicit p: Parameters) extends LazyModule {

  // Create a simple device for this peripheral
  val device = new SimpleDevice("HMAC", Seq("lowRISC,hmac-0.6")) {
    override def describe(resources: ResourceBindings): Description = {
      val Description(name, mapping) = super.describe(resources)
      Description(name, mapping ++ extraResources(resources))
    }
  }

  val ioNode = BundleBridgeSource(() => (new HMACPortIO).cloneType)
  val port = InModuleBody { ioNode.bundle }

  // Allow this device to extend the DTS mapping
  def extraResources(resources: ResourceBindings) = Map[String, Seq[ResourceValue]]()

  // Create our interrupt node
  val intnode = IntSourceNode(IntSourcePortSimple(num = 3, resources = Seq(Resource(device, "int"))))

  // Create the alert node
  val alertnode = AlertSourceNode(AlertSourcePortSimple(num = hmac_reg_pkg.NumAlerts, resources = Seq(Resource(device, "alert"))))

  val peripheralParam = TLManagerPortParameters(
    managers = Seq(TLManagerParameters(
      address = AddressSet.misaligned(params.address,  0x1000),
      resources = device.reg,
      regionType = RegionType.GET_EFFECTS, // NOT cacheable
      executable = false,
      supportsGet = TransferSizes(1, 1),
      supportsPutFull = TransferSizes(1, 1),
      supportsPutPartial = TransferSizes(1, 1),
      fifoId             = Some(0)
    )),
    beatBytes = 4 // 32-bit stuff
  )
  val peripheralNode = TLManagerNode(Seq(peripheralParam))

  // Conversion nodes
  //val axifrag = LazyModule(new AXI4Fragmenter())
  val tlwidth = LazyModule(new TLWidthWidget(beatBytes))
  val tlfrag = LazyModule(new TLFragmenter(1, blockBytes))
  val node = TLBuffer()

  peripheralNode :=
    tlfrag.node :=
    tlwidth.node :=
    node

  lazy val module = new LazyModuleImp(this) {

    val io = port
    val (interrupts, _) = intnode.out(0) // Expose the interrupt signals
    val (alerts, _) = alertnode.out(0) // Expose the alert signals

    // Instance the HMAC black box
    val blackbox = Module(new hmac_wrapper)

    // Obtain the TL bundle
    val (tl_in, tl_edge) = peripheralNode.in(0) // Extract the port from the node

    // Clocks and resets
    blackbox.io.clk_i := clock
    blackbox.io.rst_ni := !reset.asBool

    // Connect the external ports
    (alerts zip blackbox.io.alert_rx_i).foreach{ case(j, i) =>
      i.ack_n := j.alert_rx.ack_n
      i.ack_p := j.alert_rx.ack_p
      i.ping_n := j.alert_rx.ping_n
      i.ping_p := j.alert_rx.ping_p
    }
    (alerts zip blackbox.io.alert_tx_o).foreach{ case(j, i) =>
      j.alert_tx.alert_n := i.alert_n
      j.alert_tx.alert_p := i.alert_p
    }

    // Connect the interrupts
    interrupts(0) := blackbox.io.intr_hmac_done_o
    interrupts(1) := blackbox.io.intr_fifo_empty_o
    interrupts(2) := blackbox.io.intr_hmac_err_o

    // Connect the TL bundle
    blackbox.io.tl.a <> tl_in.a
    tl_in.d <> blackbox.io.tl.d

    // Tie off unused channels
    tl_in.b.valid := false.B
    tl_in.c.ready := true.B
    tl_in.e.ready := true.B
  }

  val logicalTreeNode = new LogicalTreeNode(() => Some(device)) {
    def getOMComponents(resourceBindings: ResourceBindings, children: Seq[OMComponent] = Nil): Seq[OMComponent] = {
      val Description(name, mapping) = device.describe(resourceBindings)
      val memRegions = DiplomaticObjectModelAddressing.getOMMemoryRegions(name, resourceBindings, None)
      val interrupts = DiplomaticObjectModelAddressing.describeInterrupts(name, resourceBindings)
      Seq(
        OMHMACDevice(
          memoryRegions = memRegions.map(_.copy(
            name = "HMAC",
            description = "OpenTitan HMAC-SHA256 HWIP"
          )),
          interrupts = interrupts
        )
      )
    }
  }
}

case class HMACAttachParams
(
  par: HMACParams,
  controlWhere: TLBusWrapperLocation = PBUS,
  blockerAddr: Option[BigInt] = None,
  controlXType: ClockCrossingType = NoCrossing,
  intXType: ClockCrossingType = NoCrossing)
(implicit val p: Parameters) {

  def attachTo(where: Attachable)(implicit p: Parameters): HMAC = {
    val name = s"HMAC_${HMAC.nextId()}"
    val cbus = where.locateTLBusWrapper(controlWhere)
    val clockDomainWrapper = LazyModule(new ClockSinkDomain(take = None))
    val per = clockDomainWrapper { LazyModule(new HMAC(cbus.blockBytes, cbus.beatBytes, par)) }
    per.suggestName(name)

    cbus.coupleTo(s"device_named_$name") { bus =>

      val blockerOpt = blockerAddr.map { a =>
        val blocker = LazyModule(new TLClockBlocker(BasicBusBlockerParams(a, cbus.beatBytes, cbus.beatBytes)))
        cbus.coupleTo(s"bus_blocker_for_$name") { blocker.controlNode := TLFragmenter(cbus) := _ }
        blocker
      }

      clockDomainWrapper.clockNode := (controlXType match {
        case _: SynchronousCrossing =>
          cbus.dtsClk.map(_.bind(per.device))
          cbus.fixedClockNode
        case _: RationalCrossing =>
          cbus.clockNode
        case _: AsynchronousCrossing =>
          val clockGroup = ClockGroup()
          clockGroup := where.asyncClockGroupsNode
          blockerOpt.map { _.clockNode := clockGroup } .getOrElse { clockGroup }
      })

      (per.node
        := blockerOpt.map { _.node := bus } .getOrElse { bus })
    }

    (intXType match {
      case _: SynchronousCrossing => where.ibus.fromSync
      case _: RationalCrossing => where.ibus.fromRational
      case _: AsynchronousCrossing => where.ibus.fromAsync
    }) := per.intnode

    LogicalModuleTree.add(where.logicalTreeNode, per.logicalTreeNode)

    per
  }
}

object HMAC {
  val nextId = {
    var i = -1; () => {
      i += 1; i
    }
  }
}