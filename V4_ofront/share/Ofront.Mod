MODULE Ofront;	(* J. Templ 3.2.95 *)

	IMPORT Kernel,
		OPP := OfrontOPP, OPB := OfrontOPB, OPT := OfrontOPT,
		OPV := OfrontOPV, OPC := OfrontOPC, OPM := OfrontOPM;

	PROCEDURE Module*(VAR done: BOOLEAN);
		VAR ext, new: BOOLEAN; p: OPT.Node;
	BEGIN
		OPP.Module(p, OPM.opt);
		IF OPM.noerr THEN
			OPV.Init;
			OPV.AdrAndSize(OPT.topScope);
			OPT.Export(ext, new);
			IF OPM.noerr THEN
				OPM.OpenFiles(OPT.SelfName);
				OPC.Init;
				OPV.Module(p);
				IF OPM.noerr THEN
					IF (OPM.mainprog IN OPM.opt) & (OPM.modName # "SYSTEM") THEN
						OPM.DeleteNewSym; OPM.LogWStr("  main program")
					ELSE
						IF new THEN OPM.LogWStr("  new symbol file"); OPM.RegisterNewSym
						ELSIF ext THEN OPM.LogWStr("  extended symbol file"); OPM.RegisterNewSym
						END
					END
				ELSE OPM.DeleteNewSym
				END
			END
		END ;
		OPM.CloseFiles; OPT.Close;
		OPM.LogWLn; done := OPM.noerr
	END Module;

	PROCEDURE Translate*;
		VAR done: BOOLEAN;
	BEGIN
		OPM.OpenPar;
		OPT.bytetyp.size := OPM.ByteSize;
		OPT.sysptrtyp.size := OPM.PointerSize;
		OPT.chartyp.size := OPM.CharSize;
		OPT.settyp.size := OPM.SetSize;
		OPT.realtyp.size := OPM.RealSize;
		OPT.inttyp.size := OPM.IntSize;
		OPT.linttyp.size := OPM.LIntSize;
		OPT.lrltyp.size := OPM.LRealSize;
		OPT.sinttyp.size := OPM.SIntSize;
		OPT.booltyp.size := OPM.BoolSize;
		LOOP
			OPM.Init("translating", done);
			IF ~done THEN EXIT END ;
			OPM.InitOptions;
			Module(done);
			Kernel.GC(TRUE);	(* someone might Oberon.Call("Ofront.Translate"...), so we have to mark the stack *)
			IF ~done THEN EXIT END
		END
	END Translate;

BEGIN
	OPB.typSize := OPV.TypSize; OPT.typSize := OPV.TypSize
END Ofront.
