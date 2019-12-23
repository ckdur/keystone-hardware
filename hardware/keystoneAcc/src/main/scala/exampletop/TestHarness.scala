// See LICENSE.SiFive for license details.

package uec.keystoneAcc.exampletop

import Chisel._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.devices.debug.Debug
import freechips.rocketchip.diplomacy.LazyModule

class TestHarness()(implicit p: Parameters) extends Module {
  val io = new Bundle {
    val success = Bool(OUTPUT)
  }

  val dut = Module(LazyModule(new ExampleRocketSystem).module)
  dut.reset := reset | dut.debug.ndreset

  dut.dontTouchPorts()
  dut.tieOffInterrupts()
  dut.connectSimAXIMem()
  dut.connectSimAXIMMIO()
  dut.l2_frontend_bus_axi4.foreach(_.tieoff)
  Debug.connectDebug(dut.debug, clock, reset, io.success)

  dut.usb11hs.USBWireDataIn := 0.U
  dut.usb11hs.vBusDetect := true.B
  dut.usb11hs.usbClk := clock // TODO: Do an actual 48MHz clock?
}
