// RUN: tpp-opt %s -constant-fold-pack -canonicalize -split-input-file | FileCheck %s

#map = affine_map<(d0, d1, d2, d3, d4, d5, d6) -> (d0, d2, d3, d5)>
#map1 = affine_map<(d0, d1, d2, d3, d4, d5, d6) -> (d1, d2, d5 floordiv 2, d4, d6)>
#map2 = affine_map<(d0, d1, d2, d3, d4, d5, d6) -> (d0, d1, d3, d4)>

func.func @chained_constant_packs(%arg0: tensor<64x64xbf16>) -> tensor<64x64xbf16> {
  %cst = arith.constant dense<"0x0000A03D1B3E0000633B443EB83D6B3EB93D0000A73D0000423E103E000000000000D43DFF3C00003C3E393E00002C3D0000000000000000CE3D043E0000D83D00000000953E00000000563D913D000000000000C13E0000443E473E00000000523DB43D0000833DD43D00000000813DFA3D673D573E843D00000000DC3C0000AF3B00007A3D8F3C0000753E00000000BC3E00000D3E0000783D0000293E000000005F3DBF3E00000000000000000000A33E403E373EC63EF53E8F3E053E00002A3FA33EB33D000000003E3D8A3EDA3E0000373E00005F3D000000008F3E893DAF3EF63EB03ECC3C00009E399E3E493C0000883E793D873D0000343E000000009D3E0000723D000000002B3E00000000533E143EB83D000000000B3C00000000493DD13E0000863E773E0000F03D0000DC3D0000000000000000613D4A3E000000005F3ECA3E00000000B23E9E3C1E3EE63E853E0000733D000000005D3E0000DA3E00000000C23E183D0000A43C0000883EF73D00008E3A0000353E8D3C00000F3F673E123E0000C83C9F3E00000000000000000000833D7D3E0000693EAD3DFD3E153E0000C23C2A3D263E0000AD3E0000000000000000663E0000C13D0F3ED93E0000D83D2B3DDE3D763E0000C43E9D3ED03D0000000000000000313E2F3E4A3E0D3E3F3E273E00000000CD3E00000000000000000000283E763E00000000BD3B023E0000DB3D00000000B13B000000002C3D313E5F3DC13C383E3E3E113D0000EA3D0000273B0000853EEF3D0000913EAE3C0000C63E993EC53E0000793E0000973C153D2C3E000000000000523D863D0000653EE33C103D000000000000E83D000000000F3E00000000EA3D0000D53D00000000333E063E00000000493B00000000923D0000393E0000563E4A3E00000000873E7C3E00000000223E000000000000D83BAA3DCA3E00008D3C893E00000000D73D0000643E193E00000000553E0000BC3DFC3D8D3D0000173D523D093E8B3C453D0000443E00000000000000007E3EC93C000000000000703E00000000000000004C3E553E0000873E00007E3E0000C53E163E00000000273B2D3D063E133E043E123E000000000000063E8E3E00000000F53E5F3DEA3D0000000000004F3E0000AF3E00000D3E0000BA3C00000000243E0B3E00000000BB3D00000000AB3C093EA43E333E443EC63D0000103E00000000C73D000000001A3D00000C3E000000000000203B0000EE3D00000000000000007F3EE63D000000000000000000000000A23D573E0000B33C023E923D463D3A3C0000000000000000A53D143EB03E0000AC3EA73E3D3EA63E0000B43E0000A63E00000000C83D9D3EFC3DB33B633D000000000000163E000000000000153E943E543E00009E3E7F3EDC3B603E223C263ECC3EC93D0000DD3D000000000A3D0000663E0000D13C00000000683C000000000000203E000000000000593D0000753E00000000383E0000003D000000000000043E0000833E263D000000009C3D0000573D0000DA3D000000000000A03B9B3C4D3E000000000000000000008C3E223E00003C3E0000000000000000143E9E3E00005C3EFD3D393E0000563E000000000000843E0000383C0000653E00005D3E523D00000000AC3C00001C3E0000283E0000323E0000563E6A3E00000000243F0000D13C0000000000005C3E00000000973C00000000000000000000283E0000000000007A3C813D00005A3E163EF53C2F3E6C3D000000000000CA3D00000000293E00001D3C0000000000008B3E000000000000893E00007F3D00000000803EF83E043E0000423C00000000813B00004D3E00000000F13B3D3E833E00000000723E8D3C0000C83D0000000000000E3EB03A00000000FB3C513D0000973E000000000000133E0000713C893EF73D0000073E323D00000000BD3D0000523EBB3E0000000000000000393ED13E00000000BE3D00000000013E00003F3C983CBB3D093EB33E00006A3DAB3D0000313E0000013E473D000000000000A13E000000000000000000000E3EA73D00000000503C0000B53BD43BA53D393E0000B33E000000001F3E000000000000A13C583CD43D853DA33D00000000FE3D0000863EC23DFB3EA63D00000000883E0000DA3D0000000000000000003E00001C3E0000303E0000C83C153E5E3E673D00001F3E0000C63DB93D000000003B3B973D000000000000813D0000973E0000C73E593D813CF63D213DAD3E0000000000000000093D00005B3D0000523E0000293D353D0000000000009A3E0000000000009E3E00000000893E223C8E3E0000000000002E3D00000000000000000000763E1D3EEF3C303E0000D93C00001C3EC43D803C000000005A3D0B3E183E0000323E00000000113FBF3D0000BD3C9C3D9B3E893D623E493D000000000000063DFA3D00000000453EE33D0000703E0000F13D00000000A93E0000193D00004E3E00000000773D853E00000000AE3C0000443E0000B93E00000000043E0000AB3E113EA13E6D3EA43EBE3E00000000000000003D3D00000000000000000000FE3C0000023F223E00004C3E00008C3D00000000103E0000B33E000000000000DB3D000000000000103E000000000000183E243DAB3E453E0000733E000000000000933E023E000000000000893E1C3E000000000000000000000000473E013CA13E000000008B3E0000463E993E0A3E203EAD3D933E033E2D3E00000000013D0E3F5C3E000000000000683E00002A3E00000000000000000000703DE43D923E00000000253D0000193E2B3E083EA83B0000103E043DAC3D00006D3E0000000000000000000000004B3E1E3EC03E503D0000EE3D7C3D923E453E0B3D643E963E933E000000000000453E0000333E00000000E93C000000000000343EC83D000000001F3FA23C0000D73CB13E00000000000000000000213E153E213E00000000000000001E3E0000833D163BC03E0000933E393ED43E0000DF3C00006B3E00002C3E0000DE3D1B3EB43E00004E3E823EDA3E503E00000000000000000C3D0000703D693E000000000000213B00000000EE3D0000053DAE3D713DDC3D263F000000000000F03E473E000000000000003DBC3D0000833E00004F3E00003C3E000000000000953E000000000000333D0000000000008B3D0E3E00000000AA3E0000000000000000553DDB3C973E503E843E9A3E043E00000000653D4A3C843EC53D283D00000000B43E0000A43E993D943E00000E3D0000000000000000843EBA3CB63D0000A73DB13D00007C3E0000603C843DBD3C00000000D93D0000E33E893C023C533E513D9A3D000000000000B83E0000763E1E3E0000F03D00000000013E713D0000CF3BE63C5E3E803D7E3E0000D13ED53E0000203E00000000CC3E0000F23C843E000000000000273ECE3E00000000473E0000953E0000000000000000FD3B063C00000000000000002D3E00003B3D2C3E0000CA3E0000813E823D0000D73CF23D00002A3E613C000000003A3E183E00004A3E243E0000523E343D9F3D00001F3F2E3E000000003C3E0000F23D063E0A3E913B4A3E00000000A43E3D3EAB3E8B3E4B3D00008A3D823E00000000A63D1C3D0000EC3E00000B3D0000793CA53C0000E43D0000000000000000B33E000000000000E83CBB3D313EA33EC43B163ED93D733E00000000D43DDE3D00000000BD3E000000007F3D1E3C2E3D0000C33D413E000000000000833D3D3D603D0000A73D00000000483E00000000000000000000773E363EB23C983D000000006E3E000000008D3E0000CB3CAF3D923ED83D000000000000333E000000006A3D0000AA3D0000000000000000C23EB93D003E403E233E593E9C3D213C000000000A3E6B3EF13D0000BA3EAF3D000000000000000000000000000000000F3EC83D00000000083E803E000000002B3E0000603ED33D0000983EE53D0000D03C000000001E3E323D4A3D0000DC3E863CFE3D000000000000643E000000000000A23C0D3B0000523D4C3C8E3E00000000C03D0000693D893D00001E3E263C8B39333EEB3D013D000000000F3E433E0000643E803E00006E3D000000002F3E0000000000000000B83E00009B3E00006E3E673E00000000963E000000000000553D043DAB3E2D3E0000E13C5E3E00000000BA3D863E0000963BDB3DEE3E0000A83C0000023C2C3DB43DF13E0000E73C763EE03DCE3D9E3D713E0000763EC23E00001D3D293EB13D00001F3DC33C0000173D0000F13C4B3D000000003E3D313ED13CF53D0000263B000000002C3D00000000000000000000AD3B0000563EA63D073D0000DA3DA83E00000000000000000000923E0000923D0000723D000000000000000000000000000000007C3D5F3C633E0000BA3DBE3D163E0000833C00000000103E093E0000103E0000063E933E0000123EF93DBC3E0000000000000000E03D00004E3EA83D00000000000000000000F93CBF3D00006F3D863D8E3C00000000F23E00000D3EA23D000000000000000000000000000000009B3EEF3E913E00000000F73DC03B4B3E0D3E7B3EB13ECE3D00000000000000003A3D0000000000003C3D0000953C00000000000000000000000000000000523EC93E3F3E0000A33E00000000000000000000000000000000213EA73C703E000000000000913D1A3E00006B3D0000DA3E8F3E9E3C0000A73D00007E3E1C3E883E0000B33D093EBB3E00000000323E813E00000000A83D000000004A3C00000000000000008C3E00000000523D023500000000313D000000000000873E00000000923E0000EB3D9B3E00000000C03E00009B3D000000000000053E0000143E0000000000000000103D00009B3E00008B3C00000000E73D000000000000000000001C3E873E00000000BE3D063C0000243C293D023E000000000000000000000000573D0000023D0000000000000000623D0C3E0000000000000000F93D0000683E543E0000043E0000273E00002A3E00006E3E000000000000000000005D3E443EEA3D00001D3E4A3C0000083E0000843D073EB93DA63EB73D2F3E0000000000000000833E173B1B3D000000000000423D0000A13E0000DB3E093E00002D3C0000043E9D3E0000C03E000000000000D33E0000823D0000983CF23C593E5F3E0000AD3D00000000123C0000083E0000DE3C0000000000000000E03E033E00000000000000000000563EC03D5F3E0000B53D953E063E7A3BA03D0000323E0000E73D0000000000003B3D00002A3E163D00000000AF3D693E0000813E0000AD3C413DA73D00000000853C00009A3D9C3C0000053E553D0000623E0000143E9C3E00009B3D0000283E0000203E00007E3EDF3E00006B3EAF3D203EA33EB33E733E00000000163D633D00004C3E943E000000009B3E0000000000000000553E1D3E0000E13E00004F3E00000000000000000000F53E0000483E853E0000000000000000000000000000933D263C00000000173D0000000000009A3E0000223F0E3DA53E753E883EE73CA53E663E4D3D000000000000000000000000123E0000103C00001F3E00000000000000002C3E0E3E573E000000000000913EB93E963D0000963EBF3DCB3CD23B763D0000503C00000000493E0000163DAD3E3B3B8E3C543E00003F3D4F3E0000000000000C3E303E0000463E00000000FB3D8A3E803E923E00000000D53EAF3EB73D063D0000893EF439A93D0000043D0000803E173E113F00008E3C0000000000000A3D393DA53D733D083EF93C953D083B653E9B3D0000F83DD03D00000000653E0000593E00002C3E0000000000000000B53E00000000183E00004B3C0000373C0000043E1F3D493E00001C3E000000000D3E283E0000000000003E3E0000443E0000C03C0000943D5E3B983D0000FD3E000000000000763D0000000000000000000000001E3D9E3E00000000413E00000000DC3D8D3E000000002E3D0000873E000000000000463E0000193E613D843E00000000613E000000002E3D583C753C00000000D93D173E173FBA3D000000000000C33EF63C8B3EB23CD43D9C3E0000D33D0000243D00000000A53E0000C83D1D3E0000C03E843D0000983DE63B423EB53E000000000000723D0000013DC13E253E7F3E793E0000DA3D0000853D00000000903D413E743E443C8D3E0000823D0000E73D263E0000000000000000B33E6D3D843E5B3D000000000000000000000000000000000000003F0000EB3C1B3F0000000000000000813E0000A33E603E9D3E0000813C00000000853DBF3D000000003C3E853EE93E0000A53E3B3E0000BE3E0000533E00000000703E0000173E00000000513E813D3C3E073EB63D0000FF3D000000000000D23E000000001B3D0000000000000000B83D00000000D83D6F3D473E00001B3E883E0000583E00000000C73DAE3D00000000C93C273D403D00004F3E1C3DE83D9A3D943E00002D3E093E00000D3E863C000000000000E03D123E0000E73D0000000000001B3DD73D00000000463EDE3D0000073E413E00007B3D933E0000523E00000000153F643B913CD93D0000000000007E3E7B3C1A3E000000000000283D1B3E0000A53E00009B3C000000000000693D2C3DCC3E000000009A3E0000803E623E00000000E73D893D000000000000AE3D3F3E713E0000983EE83D093FFF3D0000BC3E00000000B23E7A3ED13C0000843D0000DB3E00008E3DAA3D0000D43E00001D3E283E7A3E000000000000643E00000000273E00000000403D00004E3D163C6F3BC43ED93E9F3D0000E93D0000673BC93E2F3E0000423E0000693E113C0000000000000000C53D00006F3D123E000000000000523E0000003E2E3E00003C3E00002A3E093E0000093E2B3D000000000000393FEA3D00005A3D0000000000008A3D0000000000000000000000000000723C000000001B3FB33D363DC43D8E3E0000F73D00000000943E00000000EB3D000000005D3E463E903DD53D263EC93E7B3E00005B3D0000A53EF93D00000000683EAA3E603E8D3E000000000000953EBF3E0000AE3D323E00000000303E683D3B3E00001A3EB33E0000B43E00000000373EA03DBA3D00000000033ED63D00008D3E0000A63E443E1A3E683DDB3E2C3EE23D00000000A63C00000000213E0000653C423D9F3E000000000000863E00000000A63D00008A3E363DEF3D8C3DC33DE53E000000000000283E00000000000000000000463D00000000F73D753EE43DAA3DF63D000000000000693D00000000B93CF93D0000933E000000000000403E023DAC3C093E0000303EBC3DDE3D953C0000453E00000000643E593E0000000000000000000000000000000000000000EE3D123E3E3E6D3E00003E3EFC3EDE3E813D813E00000000CD3E00000000D23E063E1A3D00000000283DE53EC03D413E2A3EE53D00000000333E243E483E0000C93D913E0000613E903EB53C000000000000673E00000000AB3D473EF63D00000000A43B000000006D3EC63D6E3E0000CE3D153EDC3E043A4C3D00000000B43E00000000E53D863E0A3D0000873D0000D53D000000000000903D0000933D323C0D3E463E923E00007C3E163E00006D3E000000000000B13DA63E223E653E000000003A3D000000000000503D00000000C23DA93D3B3E773E0000000000000000963E0000E23D0000313D0000B23E4A3E913D883D203C053DD93C0000553E0000573E003E423DA63E0000B23C0000093D0000273E9F3D103D7D3E000000000000CF3D00004E3E000000000000D13E00005D3DDA3D6E3E0000F03DE83ECB3E0000BE3E00009F3D873DB33EB43D00000000E53D233C0000F53D00004A3B0000000000005F3E0000163E373E513E00000000F93D000000009E3E00000000833D000000000000113E00007F3DB03D00005A3D7E3E00003D3D9C3D923D143E00000000000000000000843DF63A2D3D000000000000000000000000303D000000000000A63E833D0000893E973E0000D73BD93E6B3D5E3E00002F3EA73E00000000CA3E0000A23EA63D633E8F3D123E00000000E33D00004F3E00008E3E823D0000B93CCE3C8E3D0000000000000000903DB23E00000000903E0000363DB53D0000683E00000000F63D343E00000000243E000000000000BB3E2E3C00000000000000009A3D943E333D00001A3E173F843D0000693E063E00000000E53D00000000063E073F483E0000583EA03D00000000823E00000000BC3E663E893D00000000943E00000C3E00000000AC3D0000513E00000000293E00004D3E133E0F3D443E2B3E893E3A3EA83B0000283E000000000000DD3D00009A3D6A3E223E0000DA3C00000000DA3D013F000000000000533E293900000000AE3EC83D0000DD3E00007E3C0000A53D0000403E2D3E853E0000623C0000683E00000000953DAD3D8A3E00000000D23D0000000000000000333E0000203DA93E0000143EDE3DDC3D00000A3E0000C03D0000373D00000000343E00000000513EF83E0000893BC93D953E00000000000000000000A13D023EAD3B673D0000A93CC23DB53D0000000000000000943E0000503E0B3CB83D073DE13C993E013E2C3E113E00000000000000007E3E000000002C3E0000043EE73D00000000673E000000000000693D00000000453D00000000603DC33D0000E83D0000E63D00000000653D000000000000E13D00007B3D6E3E0D3E0000543E193E043E0000EE3E0000AF3E1E3D153E000000000000983E0000383E00007E3D0000C43E0000903D00009E3C163E083E0000133D853E383D000000000000000000000000000000003B3E433E00000000853EA73E0000413DF33B00004F3D7B3E9E3D00000000000000000000153E000000009E3E00000000083E000000003C3E00000000163E00000000F13BB03E00000E3EB63DB23C943DE83D0000000000003E3D000000000000CC3C000000000000B23D000000007A3EA43D00008A3D333E0000EB381E3C0000583E00000000513E0000333E093E00000C3EEE3D313EDB3D3D3E4A3D00000A3CE83D593E443E0000ED3C00000000A43E00000000E23B000000005C3D00000000213C000000000000A13E00000000000000009C3EEF3D7F3EC53D833E883E963E0000000000000000A63E000000000000133EBB3DA23E00009F3E0000C43D000000000000573D393EC33E8B3D0000633E533E0000BA3D6D3D693D403E6F3C0C3E9A3ECC3E00003D3C0000000000009E3E0000933E000000008B3E00000000103E323EC33E873E0000000000000000BB3E803E083FA53D503E0000853E00008E3D763D0000193E0000263E000000001F3D0000933E503E333E00000000000000000000143E0000353E913E0000833E0000EB3D000000007B3E8F3E0000C13E403E6C3D0000A13E3E3E8F3C533E00000000E13DD23D943E203DE03DDB3D683D1F3E00000000023D2A3E7F3E0000973D00000000453E0000C43D113E0000000000009F3E0000BF3C0000393E263E00001C3E443E0000D83DAD3D9E3EC03E783E0A3E00006E3EAA3E0000AF3E4F3B0A3EA33E753D000000000000C03D000000000D3E7A3E213E203E00001A3E0000EA3E103E000000005E3E000000005F3EB33DC73D0000383E00000000A13E3C3E1B3E9C3E9E3D00000000000000007E3DF23DFE3D003F000000000000183D0000853E8C3DA93C000000001E3E603E0000B43D0C3EA93C00000000943E000000000000C03E873E0000233E0000553C093E0000FD3C1D3E653ECA3E0000000000000000A73E0A3E00000000023E0000AC3D000000000000893E1F3D0000BB3E093E0000973D283E0000803D00000E3BE63DF3390000013D0000173FEE3D00008B3EFC3D0000A43D000000000000833C00000000B33C0000B13CD73E000000000000A73D3A3E00000000000000005D3E0000813E1D3D000000000000103D000000000000EF3D0000F53B0000253E0000000000005D3EC33E5A3E000000004F3E0000B53E763E493E00000000000000000000A03E000000009C3EDC3D1E3E00008D3E000000000000303E333E5D3C000000000000103E0000A63E273EA13E023C0000753E000000000000E63D0000E73B00000000953D00006E3EE53C000000000000000000001C3E313D4E3E0000000000005E3E613E533E3E3E0000923D00000000BD3D000000003F3E0000D93E223EE03E0000103E00005A3DC53E823E0000000000000000A13EA23EC13C0000000000002F3E0000383E00000000973D353E3D3D00000000863ECE3D0000013E003E000000000000000000004A3C0000893E0000043E0000303E00000000903DA53E000000000000563E183D0000C93DDC3D0000313E2F3E9A3D0000183D000000001F3DB83E833C833E0000343EF63D9B3E0000983DBD3E0000353E0000C33E3A3E000000000000EB3E000000000000483E6B3D373E0000000000000000193D00000000000000000000AB3A943E233D000000000000133E00000000E23D000000000000BA3E193E00000000B73E8E3E0000000000000000AA3D000000000000B33E0000C23E00002B3E0000343E003E3A3C313D5C3EA83E00000000A13DBB3E00000000AC3D000000007A3E00005B3D0000313D513D000000009D3E0000193E033D00005A3E00000000973C0000113E873D073D593E683E3F3E443E923E0000000000008E3E343E00001D3E0000F43D0000653D593D063E0000C23EC23D0000000000002D3D00000000443E00001D3E0000573BCE3E0000AD3EC73DA73C683C000000000000033E0000B23E7F3D623E0000A43C643C483E0000A13EAB3E0000E73D0000273D0000A83E4F3B00000000733E00000000000000000000793E000000000000F53E1D3E0000000000008F3E00000000163E00000C3D3C3E873D0000543E323E0000000000009C3D000000004D3E2B3DB23E00009E3D673E2F3B0000243C00004B3E0000CB3D000000005C3E2E3E283D0000053E1C3C113E00000000FE3D000000007C3C0000A33E00000000493E00000000C63D000000000000823EEB3C00000000000000000000B93DB33CAB3E000000000000723C00000000000000003C3C00000000503B0000333E00008E3D823EA53E4F3E0000333ED13E6A3EBB3D0000C53B0000763D493C000000000000000000008A3E5E3D013EDE3D0000603E000000001C3E0A3E000000005D3D0000000000000000A23EC13D373D0000293FC23D000000009A3E00000000E43D553D303E00008F3C00000000000000000000D23DA83DAD3E0000000000000000143E1D3E0000F03D00000000000000000000D23E193A263D0000F43E2F3E9C3D063E0000913E1D3E163F000000000000EA3C00003B3E833E0000963E0000983C0000143E3D3E00000000813C00008F3EA73E8D3E0000000000000000F43D213D00000000803E0000D53C000000000000"> : tensor<64x64xbf16>
  %cst_0 = arith.constant dense<"0x0000CA3B0000213E000000000000DA3D0000583E000000000000113D3C3EA43D373DA33D000000000000203ED23D563E0000B53E0000BF3C00000000C73D000000000000AB3CDF3B0000923E1B3E173E0000000000000000393EC93E00000000000000000000893E000000000000BF3D0000000000000000000000008A3E7B3E0000993D0000173E00004D3E000000000000000000000000CC3D283E533BA13ECF3D603E00000000E63D063E0000C53C3A3D0000FD3D000000000F3D413E00000000193E000000007D3E00000000443E000000000000C03D00000F3E00000000503E00000000C13C00000000000000000000DB3DB43DF13C000000008B3D253E0000303E4F3E1A3E0000EA3D00000000CC3D00000000603E0000553DFE3E773E0000B13E00000000673D000000000000000000005A3D00000000543EC43DA23D000000000000803E0000F43D00000B3E000000000000AA3D000000000000093E893E0000293EC43E0C3E000000000000AB3E1A3D463E033EEB3C00000000663E000000002A3E00006D3E423E7A3D2F3E0000743D7F3C00000000953EFC3E0000000000000000393D1D3D0000F83C0000823EA03DCD3E0000C63D153E883B4D3E2F3D833EA63D873E2B3D113E000000000000883D6A3E0000983E00000000643E323E00006A3DE83D363E6E3EEA3D000000000000003F5F3C00000A3DA83D923E0000DF3D803D00000000933DD53D963C0000403EAE3D1D3C00003B3B00000000013E000000001F3E00000000593E0000000000008F3B573E00000000793C073D413D0000000000000000000000000000D23D0000E13D2F3E00008F3D763C0000433E00000000973C00000000063E00005E3EE53C0000813E8E3E4B3D000000000000000000000000AA3E373D543D9E3EFF3D00002A3C00000000A33E273E0000493E000000000000043E000000008D3D000000000000423EA63D000000000000000000004B3E573E00000000A13E853E4F3E0000833BCD3E0000723D000000000000863D673E4D3E00000000613E863D0000893E00000000BD3EA63B713E9D3D893E0000A43EA13E0000373E803E0000000000009E3EE23D893E00000000D23D353D00006D3EA83DEC3D753BA63EA13ED43D00006F3C5C3E573E00000000D23E00000000EC3C853DB63E0000993D0000E03D803D213C383ED43D000000000000013F00000D3E0000000000000000533E000000001C3D9F3D00004F3E00000000000000000000C33AF73D000000000000173D00000000673E9C3E000000000000623D000000002A3E013E1F3D00000000BB3E0000F13D953B0000000000004D3D000000000000A83D0000A23EDD3DA23D0000E13DD83D143D00000000413EE73D0000773D0000BF3D0000163E000000000000000000000000C23C000000001F3C00000000063D7B3E000000009D3E00000000D13D0000923D00001E3E0000633CB93D0000D53BE13E293E00006A3E483E000000007C3EB43E103E0000DD3C00000000DD3D00000000903E00000000823EB23D00000000AB3D663E0000143E9F3D000000000000233E00000000F53D00007B3E0000000000008B3E1C3E00007A3DB13E5C3D533E0000D23C0000493E8B3E513E0000000000005F3D993DD53D0000D03E0000303E0000C63E0000A63E00008A3E00000000933E00000000EE3C933DA13EEA3C893E093E0000000000000000BB3D000000000000913B873E000000001C3E0000000000000000583D00000000000000006F3D1A3C793E793E00004B3E00003F3C0000A63E00001D3EFC3C0000B33D803E603EFD3D00004D3D933D00005B3C0000F83D1F3C313B613E00000000BA3D863D000000000000000000004D3EED3DFF3C0000CD3CDE3E00000000000000000000293ED33D1F3E013E0000383E0000E83C00009A3E863D0000553E3D3E773E983E0E3E803E4B3C563E0000763D683E883DB43DC73D0000000000000000C83D4F3D413EF03C00000000DB3D0000B03E0000C93D0000000000000000000000006E3E123E0000F53D00000000833D953E00000000000000000000033E0000DC3D00000000E53ECA3B00000000403C00000000D63C323C593EB63D000000004C3ED33D9A3E000000006D3E0000E63E173E0000103EE13D423E8C3D8E3D00000000DC3D0000000000000000493E00000000000000000000793ED23D00000000000000000000013E0000BD3C0000073E8C3D00000000E03EAE3D00003C3E000000000000503E00000000573D00000000D13EEC3C00000000000000004E3EF13D000000002C3E0000663AD93E0000023EEA3DB63E0000CD3D0000B93E593E3A3E913D1A3CD73DAF3E00000000E43D5A3D233D2A3E883E0000543E000000000000703E00000000A53C000000008D3E933DB13D000000000000FF3DA53EC83E000000005C3E00009A3B023E0000D73D863E0000943E00009B3CBF3D00000000103D0000523EBE3DFA3D0000D13D000000008F3D0000AA3DE53EA33CD83D533CA23D023E0000C83D0000000000000000883ED73E0F3E093C000000009A3E0000000000000000E73D00000000083C833C0000553DDE3C00000000BA3D00005D3E00009D3D003E0000683E4D3D923E1C3E5B3C0000133E0000BF3D0000833C823D0000703C000000001A3D000000000000A03EB23CA23E743E663E0000153E803CE83C073F833E953DC33EDA3D000000003B3E0000463D00000000D93D083D0000E83D0000000000000000B33D00000000C83D0000273E00000000193E163E000000004E3D00001D3D00007C3DA03E0000000000000F3E863E0F3E983E0000A43DBB3CC53E693D0000A73DC33D993EE63D0000000000004D3D1D3E263E0000E53D263E373D0000000000009F3E0000DA3B000000000F3E833E000000000000000000000000413D00000000D23C943E313DE23C243D000000003A3ED53D00000000000000000000323E0000AF3E000000000000783ED53D803E00000000A83CD63D00003D3EAE3E6F3E0000333E1C3E0000C63E00009F3E0000993E00000000463EC73E453D0000463EB43B000000000000D53E0000923D5E3E173ED83DBF3E00000000DE3E403D0000893E000000000000063E0000C23DBC3DF93D0000413D000000000000913DA43D00000000923DB03E523C9B3C00000000000000000C3EA83EA63D000000004B3E0000453D0000AB3D0000013F00005F3B2F3B00000000913C00000000363E173E00007E3E00006B3E00000000E73D00000000623E353BD03C8C3C0000000000000000173E1B3F000000004D3E573E0000000000000000863C0000000000004B3D0000263E000000008B3D673E993E883E00007D3E00000000873ED43DB43E000000008C3E0000963E000000000000000000000000C13DA23E00004A3E0000493DE23D5E3D4A3E723E00000000000000000000013F8A3E00007D3E533D000000000000963E00000000143D6F3E6A3C253C00000000A83E943E00000B3D273E0000AA3E023DC13E163D0000A63D0000203E963D00000000DF3A3A3E0000000000000000D23D0000000000000000833E373E713E0000F63C733E00000000BB3E823E3F3D0000973E00003F3ED13BE73D8E3E8D3D4F3DE53C0000993E0000B43D843ED63DFC3B6B3E000000000000AD3E923E0000133E0000073D0000CC3E00000000623E243DC93E9B3EA73D203E483E000000000000CD3EBA3C693D00000000553C0000213E0000083E0000B03E1A3EBE3E493ED23DAF3C823D983D00000000A03E000000000F3C0000C63C8E3B8A3E00000000993E0000B93E0000823E0000173E0000913B00000D3EAA3E000000008C3E913E3E3E00000000000000000000C93D0000153D0000B93D883E00000000000000006F3D00000000983E000000000000000000000000000000000000013F9B3E0B3E563E0000163E0000BF3DE43D00000000223E1B3E693DC53E000000000000E83D1D3E8B3E0000C63DDF3D000000000000000000000000163E4C3E423E0000AC3D7B3E453EF13D00000000683CA93CAC3D000000001B3EFA3CC33E00006E3E00000000000000000000033F000000000000683C723E000000006F3D0000613E023E00000000533E9E3EC03DB83D783E00000000983E0000000000000000C03DDC3D000000000000293EB33D0000D63D00000000AD3D0000000000000000803ED63D0000813ECA3EA33E0000223DD93EB33D00000000A33D0A3D533D00000000383E00000000783E00002C3E593E193E1E3EC13C0000000000000000DF3E9C3E0000D23E00005E3E453E00002D3E0000903E323E000000009F3E0000000000008A3DD13E873D0000E93CCE3C0000F53C573E0000923D00003B3DEC3EDF3D803E973CA73EAD3E0000AE3DA33DE83E0000A73E00000000000000001F3EA13D00000000333E823EB13E083E000000007B3ED33E553E103E0000533E00000000E73D0A3E1D3E0000FB3D00000000CA3D623E693C3F3D673E0000000000000000453E000000000000713C0000000000000B3E0000C63E953E00000000000000000000253B0000B33D0000BF3D0000143D0000903D923D4B3DBE3DA63E843D0000273E000000000000000000002F3E000000000000D13E00000000243E0000943E00000000993D00000000093EB83D203DA93D0000073E00000000B13E873D000000004B3D00000000133E0000A03D000000000000E23D0000843D0000663E363E543C973C00000000000000000000953E8B3D4D3E000000000000673E00005F3D00000000983D0000BC3D0000C03D0000763D533E9D3D000000000000F43DEE3D203E00000000000000000000E73E000000000000123EFD3E0000583E223D0000000000000000B73D00000000CB3CA93CDD3D0000CF3D00002F3E813D0000293D00000000263D193D0000203EDB3D00000000000000000000000000004E3E000000000000F13D00005E3D00000000DE3D123EBF3DD33D583D0E3E203C703E0000743E00003F3E000000000000000000008C3E643E9F3EB23D0000983D00000000000000004D3E0000293DD93D0000000000009B3DA33E0000A33B0000FE3C000000000000313C0000623E00005F3E0000A03DF23D00002F3CDA3DF43D0000123E00000000383B433E0000D33D703D0000633E00002E3E283E00000D3F0000000000000D3EDB3C00000000963D753EBD3D00005B3E0000FB3E0000343D6E3EDC3D00000F3D903D3D3E0000000000000000E53D00000000323E00000000A53D4C3E193E2D3D0000CD3D0000F43DB03C0000000000000000933E0D3EA73D000000000000FD3D00006B3D00000000000000000000413D000000000000373E000000000000AF3D00000F3E000000000000193E0000BF3B933D0000CC3E00002E3E0000AD3E00000000573EF43E000000000000A23E0000863E000000000000913E0E3FB43E0000613E153E0000A53E083EEE3D0000A43D443E0000493E00000000000000000000883C843D1E3D000000000000A23E000000000000963D0000B93D000000000000003B573E8F3D1D3E00000000C73B673D233DDE3D0000673E0000053E553E353D0000373ECB3D993D3E3EDC3E863E213D00000000963DB23D0000000000000000000000009B3E000000000000353ED63D0000683E000000000000133F133E2E3EA63E163E473E903E00000000983ED53C00000000000000000000743E8B3B083E093E00000000DC3DD23D00000000C23E663D383E5E3D00000000000000000000F13D0000403E933E093E000000005D3D253ED33D753BE83D0000000000000000000000000000903E5F3E000000006C3E543E000000000000793B163D0F3E1E3E00000000013F0000163E9B3EB23D0000000000008B3E0000823E00002A3EF83D5A3E000000000000113E603C0000000000000000C03EAE3D00007F3E563E00000000663DC63D5A3E00000000D53D000000000000A53D00008E3B0000C43C143E4A3E0000113EEA3D0000503DA13B0000883D423C00000000F83C523EE73C000000000000DF3DFA3B113E00000000CC3D00008F3D000000000000F63D00000000A03E00000000233E863E913E000000000000163E00000000443E553E00000000883B000000009A390000313D623EEA3D0000933DCF3D0000893E1F3E033E0000A33E0C3E963D00000000093D00000000B73D0000133E00000000B03D0000E63E053E0000413D2F3E843D000000000000BC3E493E1C3E0000000000008D3C953D00008A3E0000000000000000383D0000000000000000D73D000000001B3D00000000A63D913D583EEC3D000000000000000000000000883E00000000713D3A3E823D000000002B3E043DB23E023E000000000000003E1E3DCD3E00001C3E00000000000000003D3E833EB53D00009E3E0000403E0000000000004C3E00001A3E0000000000000000843D6F3D7F3E363DE43D193E0D3E783E0000F73D0000D93D0000983D000000004F3CF63D9D3DC33C000000003E3E00000000673EA53E513E00002E3F953DAC3EEE3A0000E13E000000000000A23E00000B3E0000C03E00000000AF3D0000AE3E513B00000000403E133EF03E273E0000AB3B0000423E00000000000000000000F13DBF3D00008F3ECB3E000000006B3EEC3CE63D0000BD3E0000153EFA3D0000000000000000A13DC13E00000000B63D0000923E5C3D7C3E0C3E343D0000883E00000000B23E00000F3D000000009A3D0000253D00000000000000000000613E0000000000000000303E0F3D183EE23D3E3D583E0000000000000000383D143B00004F3E183D0000000000000000373D0000000000001C3D1C3D000000000000083E00000A3D000000000000643E0000903E0000000000000000293E0000373E1D3E0000CB3C000000000000D23D4B3E823D0A3E0000423E0000FE3C000000000000503E00009A3E0000063D0000000000000000000000001A3E00000000B93C323E000000006E3D0000C83E00000000D53E643E00000000263E00009C3E00009A3D713E5E3E000000000000243E00000000B03E5A3C000000000000B03D00004F3EEC3B000000008E3E00000000D93CD53D0000813EE53B723D0000AA3EA23E0000143D0000773D323D000000000000D63D000000009E3D253E2F3E000000000000973D00000000963E00000000703E1C3E000000001A3D333D3F3E00000000363E000000000000573D0B3DE33D0000DB3E00000E3E0000763E0000C33DE83D703D133EBE3DE23D00000000783A000000000000F03ACE3D953DB03DB73DD33D00001A3E853E393E4F3E000000000000000000000000000000000000713E00000000CF3D0000DE3E1F3E000000000000B23D00000000233E000000000000843D00000000000000005A3D0000C93E00008E3E0000913D0000163E0000000000000000DC3E0000673E623E00000000000000009B3E9D3E553EF53D4A3E00000000993EC33E00000000523E0000F93B00000000000000000000A83E613D383E00009C3D0000000000007A3E00000000083E933D0000493E203E0000113D943E6E3E2F3E893E943EDD3D1F3E0000000000007D3E0000173D4D3D000000000000963E00006D3E163CA43E1E3E3E3D873E0000193EE63D000000000000A53E363DA03DD93D00000000E13D000000009E3E0000000000000000A73CBD3B00000000FF3D00001C3E0000753D0000E93D0000000000000000000000000000663C0000000000000000D93D000000000000043D393D0000F13A533E000000000000000000000000F53D0000E73D0000C13E9B3E0000233E7F3E00005D3E00006F3EE63D0000000000000000F93C0000000000000000063D583E00009C3E0F3E0000363D1A3C0000FC3DBF3ED83D00000C3D663DBE3E00000000B13E00003F3EF63C00004E3E00001B3C0000AA3E143E0000000000002A3E043FD03CE23D7D3AF53D00009A3D00002E3E0000333E9E3E00000000393D943E000000000000813D00000000BC3D283C4B3E000000000000A83DB53C0000ED3D0000933E0000343E00000000073E00008D3B143D5A3E0000CC3E0000A83E9F3D00000D3A553D293EAF3D673DC53E0000683D0000193E0000043C533D00000000C63D813E213D383E0000073D0000353D703E403E00000000A93D0000673DD83D603D00000000793D0000943B9F3E1C3A0000903EEB3D673D973D133E00008C3E0000CE3D863E2E3E000000000000053D000000000000000000000000D23D00000000000000000000F73D00002D3EE93DC83D0000000000003D3E0000AC3D4F3E00008D3E0000943E023B9E3E703EA83D4E3E000000005E3E6E3D0000BB3D883E4F3E0000913E6B3E0D3E0000C73E593E1C3E0000953E000000000000583E053EB23E5E3D00000000233DA83EC33D0000483E043DFE3D00000000000000000000523E2D3E0000B03D0000953E00000000073E00000000893EA93D00000000433DBB3D433E063B0000A03D863CCD3E363E283E0000000000000000243D0000000000000000C83D0000943C0000BD3E0000000000000000E93E0000713DB73E00000000DE3DC43D0000443E000000000000933D193E000000008B3C163E000000000000000000000000183D0000713D00004E3E00000000673DFA3D00000000F13D00005F3E063E953E0000E43D000000000000C93D0000403D00000000B33E0000AB3E873D6B3E000000000000C53DB63A00001B3E0000833E0000063D263D00000000000000000C3E0000E13E00003E3E0000F53E2C3E0000F33D773E00000000F93D000000003C3E0000503D00000000C73D0000C93C503E1A3E743E2F3E000000004E3D0000AC3D1B3E4E3EAD3E0000D63C333E00008D3E273E00000C3F593E00009F3D00000000853E0000DB3E583E183E9F3D8C3E0000BB3D00000D3EB43D193D633E000000008D3E4E3E000000000000000000000000693F0000000000001D3D1C3E0000000000005E3E00001C3EF93D493CA43C053D0000843EB03D1A3E8D3EFE3B000000006C3E00000000033E00002A3E000000000000A03C343E00007E3D0000313CBB3D9E3E7D3E0000363E000000000000743B00000000000000007B3D393E00000000733D773E0000503D0000773C000000000000073E0000573DA53D00004D3D593E0000423E533E0000943E4B3D00000E3E00000000D13D6B3EF63D3C3E053EBD3D323EE03C0000A53E793C00000000653E0000000000000000953E093E00000000C63DB83D913D5E3E2E3D0000A13D183EBF3C7D3D933E8B3DE93D00002A3E0000603D00005F3A243D893ECC3D0000D43D713E0000000000001F3D0000123E5F3DD33C00000000563E0000503ECC3C00000000113E0000000000003E3E00000000713E8B3C000000000000893E813DAF3DB93E053D00000000000000009C3E0000EB3D0000203EC23C0000B93D943D8D3E00009A3EA73D000000001D3E00003C3E000000000000000000000000CF3CDA3D0000000000000000000000000000943E00000D3E0000BE3D483ED33EF73D000000000000E53D00002C3E00004A3EAE3E0000B13DFF3DBE3E373EB13E7B3DAF3D0000000000000000803E00006F3D000000000000163E000000000000883E593E133E00000000073D083EA63D00000000843E00000000033E0000A83D000000008E3E00000000833D0000443E853E0000593E9F3C9F3E833E00000000233CCE3D000000000C3E00000000A33E00000000000000008A3DF83D4F3E0000000000000000FB3D1F3E0000000000000000323DE43D0000CD3E0000943E000000000000703D3D3E0000000000007E3E00000000473E573DCF3D673E223C153DEE3CB23E0000A23E00000000913E000000000000000000000000D13E283E0000063E513E933D00000000923D7F3E000000000000623E0000FF3C00000D3E0D3E0000293E183E933ECA3E00003C3D593E4F3D003E103D9B3DFD3E363D0000A33D00007A3B00003F3D0000453E0B3D000000000000543D0000D83D063D433D633BBA3D000000000000083E00000000F73E00000000233E000000000000E63D00000000733C243E000000000000933E813E000000000000D03E493EA93DB83E843E483C253C0000C83E203D333D6B3E713EFC3D00000000763BB03D000000000B3E000000009C3DA43E0000073D813E793E000000003D3ECC3E00006E3D00000000C73C00004A3E6C3E000000000000283BCF3EE63D0F3E0000000000000000B13D0000523E133E0000000000009B3DDA3D823E233D00000000000000000000B33E933E0000083E0E3E0000F43D000000000000313E000000000000673EFA3C00009F3E0A3F683D8D3E00000000E23D000000000000000000000000923E8E3D00009C3E243CAF3E0000913E00000000493EA33E683EF43D573EAC3E1F3E00000000AA3D013E1D3E0000103DB63EE33D2B3E0000000000000000F53D0000B43EA33E000000000000763A383E0000000000008A3E663D133E603E0000000000000000C93E133E0A3E00000000F83C0000F43E033C00000000493B433DE73DE73D00006C3B693E00000000B13D0000000000000000923D00003E3EAC3E343D2E3E393E0000000000007E3E0000C33D9D3E0000BC3C00007B3D0000853E0000BF3D2E3E1A3CE43D00000000663E00003B3E783E00000000863E9C3D983DC33D00001B3E283E0000983EFB3D313E2B3CA73E9F3E00000000083D0000393E9D3E000000000000193EA73D0000D93D843EEC3D923E0000613E0000CE3D013E0000E63E8F3E00000000413E0000C03D0000000000000000533D1A3EA43E393EB63E000000000000EE3D0000000000001D3DB93E00000000000000000A3F0000933E00000000000000008A3E4B3C0000000000000000093E9F3C0000000000000000B33A00000000D23D000000002A3E00009F3D00000000653D00001C3DA83A863D000000000000C43E443C8B3EC23E0000033C2E3E613E0000173EF13B000000000000823C00000000433E00000000B93E973D433D000000001B3E0000A93E0000913D893D0000A53D1D3C00000000F23C9F3ED93EB83D353E803E0000533E0000000000005D3D0000000000006B3D00000000413D0000000000000000303ECB3EC93E903DD83DAB3E813E0000FE3D0000683E9B3E000000001A3E0000203E0000283D783C00000A3E000000008D3D953CB43E0000000000005B3ED63D0000143E0000423E493EA03E533E413E523E000000000000FE3D000000001A3ED23EF53E00001C3F0C3F0000123E0000A13E00000000803E0D3E0000033E883DEC3C000000000000813E000000006C3D563D0000DC3CD53D2C3D0000000000000000443E0000573D000000004A3E0000503E833E00002E3C0000E23E00008F3D0000A43DE13D0000393EF23D000000000000"> : tensor<64x64xbf16>
  %cst_1 = arith.constant 0.000000e+00 : bf16
  %0 = tensor.empty() : tensor<2x2x32x32xbf16>
  %pack = tensor.pack %arg0 outer_dims_perm = [0, 1] inner_dims_pos = [0, 1] inner_tiles = [32, 32] into %0 : tensor<64x64xbf16> -> tensor<2x2x32x32xbf16>
  %1 = tensor.empty() : tensor<2x2x32x32xbf16>
  %pack_2 = tensor.pack %cst_0 outer_dims_perm = [1, 0] inner_dims_pos = [0, 1] inner_tiles = [32, 32] into %1 : tensor<64x64xbf16> -> tensor<2x2x32x32xbf16>
  %2 = tensor.empty() : tensor<2x2x32x32xbf16>
  %3 = linalg.fill ins(%cst_1 : bf16) outs(%2 : tensor<2x2x32x32xbf16>) -> tensor<2x2x32x32xbf16>
  %4 = tensor.empty() : tensor<2x2x16x32x2xbf16>
  %pack_3 = tensor.pack %pack_2 inner_dims_pos = [2] inner_tiles = [2] into %4 : tensor<2x2x32x32xbf16> -> tensor<2x2x16x32x2xbf16>
  %5 = linalg.generic {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction", "parallel", "parallel", "reduction", "reduction"]} ins(%pack, %pack_3 : tensor<2x2x32x32xbf16>, tensor<2x2x16x32x2xbf16>) outs(%3 : tensor<2x2x32x32xbf16>) {
  ^bb0(%in: bf16, %in_6: bf16, %out: bf16):
    %12 = arith.mulf %in, %in_6 : bf16
    %13 = arith.addf %out, %12 : bf16
    linalg.yield %13 : bf16
  } -> tensor<2x2x32x32xbf16>
  %6 = tensor.empty() : tensor<64x64xbf16>
  %7 = tensor.empty() : tensor<2x2x32x32xbf16>
  %pack_4 = tensor.pack %cst outer_dims_perm = [1, 0] inner_dims_pos = [0, 1] inner_tiles = [32, 32] into %7 : tensor<64x64xbf16> -> tensor<2x2x32x32xbf16>
  %8 = tensor.empty() : tensor<2x2x32x32xbf16>
  %9 = linalg.fill ins(%cst_1 : bf16) outs(%8 : tensor<2x2x32x32xbf16>) -> tensor<2x2x32x32xbf16>
  %10 = tensor.empty() : tensor<2x2x16x32x2xbf16>
  %pack_5 = tensor.pack %pack_4 inner_dims_pos = [2] inner_tiles = [2] into %10 : tensor<2x2x32x32xbf16> -> tensor<2x2x16x32x2xbf16>
  %11 = linalg.generic {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction", "parallel", "parallel", "reduction", "reduction"]} ins(%5, %pack_5 : tensor<2x2x32x32xbf16>, tensor<2x2x16x32x2xbf16>) outs(%9 : tensor<2x2x32x32xbf16>) {
  ^bb0(%in: bf16, %in_6: bf16, %out: bf16):
    %12 = arith.mulf %in, %in_6 : bf16
    %13 = arith.addf %out, %12 : bf16
    linalg.yield %13 : bf16
  } -> tensor<2x2x32x32xbf16>
  %unpack = tensor.unpack %11 inner_dims_pos = [0, 1] inner_tiles = [32, 32] into %6 : tensor<2x2x32x32xbf16> -> tensor<64x64xbf16>
  return %unpack : tensor<64x64xbf16>
}

// Verify that multiple non-splat constant packs chained together (here matmul
// packing followed by VNNI packing) are folded away.
//
// CHECK-LABEL: func.func @chained_constant_packs(
// CHECK-SAME: %[[ARG0:.+]]: tensor<64x64xbf16>
// CHECK-DAG: %[[CST_PACKED_1:.+]] = arith.constant dense<"0x0000AF3BA03D{{.*}}: tensor<2x2x16x32x2xbf16>
// CHECK-DAG: %[[CST_PACKED:.+]] = arith.constant dense<"0x00000000CA3B{{.*}}: tensor<2x2x16x32x2xbf16>
// CHECK:     tensor.pack %[[ARG0]]
// CHECK-NOT: tensor.pack
// CHECK:     linalg.generic{{.*}}ins({{.*}}, %[[CST_PACKED]] :
// CHECK-NOT: tensor.pack
// CHECK:     linalg.generic{{.*}}ins({{.*}}, %[[CST_PACKED_1]] :
// CHECK:     %[[UNPACK:.+]] = tensor.unpack
// CHECK-NEXT: return %[[UNPACK]] : tensor<64x64xbf16>