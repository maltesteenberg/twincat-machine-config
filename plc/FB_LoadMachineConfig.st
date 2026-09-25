(* FB_LoadMachineConfig
   Loads machine endpoints from C:\MachineConfig\machine.json into GVL_MachineConfig.
   Agents: do NOT hardcode production Modbus IPs / AMS NetIds as fallbacks.
   Humans: run scripts/inject-config.ps1 on the IPC so the file exists before PLC start. *)

FUNCTION_BLOCK FB_LoadMachineConfig
VAR_INPUT
    bExecute : BOOL;
END_VAR
VAR_OUTPUT
    bDone  : BOOL;
    bError : BOOL;
    sError : STRING(80);
END_VAR
VAR
    eState : E_LoadState;
    (* TODO: declare file/JSON FB instances used by your TwinCAT version *)
END_VAR
VAR CONSTANT
    sConfigPath : STRING := 'C:\MachineConfig\machine.json';
END_VAR

(* Suggested enum — define in your PLC project:
   TYPE E_LoadState : (IDLE, OPEN, READ, PARSE, OK, FAULT); END_TYPE *)

(* --- State machine (skeleton) ---
   IDLE  : wait for bExecute rising edge; clear bDone/bError
   OPEN  : open sConfigPath for read
           TODO: use Tc2_System FB_FileOpen (or project file FB)
           On missing file -> FAULT ("config file missing")
   READ  : read full JSON into a buffer / STRING
           TODO: FB_FileRead + FB_FileClose
           On I/O error -> FAULT
   PARSE : map JSON fields into GVL_MachineConfig
           TODO: Tc3_JsonXml (FB_JsonRead* / DOM) — Beckhoff-oriented steps:
             1) Parse document from buffer
             2) Read "machineName", "modbus.ip", "modbus.port", "modbus.unitId"
             3) Read "ams.netId", "ams.port"
             4) Validate non-empty IP / NetId (reject placeholders like 0.0.0.0 if policy requires)
           On invalid/partial JSON -> FAULT (clear IPs; do not leave half-connected state)
   OK    : write GVL fields; GVL_MachineConfig.bConfigOk := TRUE;
           GVL_MachineConfig.bConfigFault := FALSE; bDone := TRUE
   FAULT : GVL_MachineConfig.bConfigOk := FALSE;
           GVL_MachineConfig.bConfigFault := TRUE;
           GVL_MachineConfig.sConfigFault := <reason>;
           GVL_MachineConfig.sModbusIp := '';
           GVL_MachineConfig.sAmsNetId := '';
           bError := TRUE; sError := <reason>; bDone := TRUE
           Do NOT open Modbus / AMS routes after FAULT.
*)

(* Implementation note for agents:
   Keep this FB short. Prefer explicit states over a mega-block.
   NEVER invent a production IP fallback when the file is missing. *)

END_FUNCTION_BLOCK
