(* GVL_MachineConfig — runtime machine endpoints loaded from C:\MachineConfig\machine.json
   Never hardcode production Modbus IPs or AMS NetIds here. *)
VAR_GLOBAL
    sModbusIp      : STRING(15);
    nModbusPort    : UINT := 502;
    nModbusUnitId  : USINT := 1;
    sAmsNetId      : STRING(23);
    nAmsPort       : UINT := 851;
    sMachineName   : STRING(32);
    bConfigOk      : BOOL;
    bConfigFault   : BOOL;
    sConfigFault   : STRING(80);
END_VAR
