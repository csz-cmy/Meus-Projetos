object dxLayoutLookAndFeelListDesignForm: TdxLayoutLookAndFeelListDesignForm
  Left = 532
  Top = 129
  AutoScroll = False
  ClientHeight = 489
  ClientWidth = 370
  Color = clBtnFace
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 370
    Height = 489
    Align = alClient
    TabOrder = 0
    TabStop = False
    object lbItems: TListBox
      Left = 12
      Top = 40
      Width = 346
      Height = 129
      Style = lbOwnerDrawFixed
      BorderStyle = bsNone
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 1
      OnClick = lbItemsClick
      OnKeyDown = lbItemsKeyDown
    end
    object tlbGroups: TToolBar
      Left = 10
      Top = 10
      Width = 46
      Height = 22
      Align = alNone
      AutoSize = True
      Caption = 'Commands'
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = ilMain
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object tbAddItem: TToolButton
        Left = 0
        Top = 0
        Action = acAdd
        DropdownMenu = PopupMenu1
      end
      object tbDelete: TToolButton
        Left = 23
        Top = 0
        Action = acDelete
      end
    end
    object lcPreview: TdxLayoutControl
      Left = 22
      Top = 232
      Width = 313
      Height = 235
      BevelKind = bkSoft
      TabOrder = 2
      TabStop = False
      object cxTextEdit1: TcxTextEdit
        Left = 95
        Top = 119
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        TabOrder = 1
        Text = 'cxTextEdit1'
        Width = 180
      end
      object cxMemo1: TcxMemo
        Left = 10000
        Top = 10000
        Lines.Strings = (
          'cxMemo1')
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        TabOrder = 8
        Visible = False
        Height = 108
        Width = 203
      end
      object cxCheckBox3: TcxCheckBox
        Left = 22
        Top = 185
        Caption = 'cxCheckBox1'
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        TabOrder = 3
        Transparent = True
        Width = 265
      end
      object cxTextEdit2: TcxTextEdit
        Left = 95
        Top = 146
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        TabOrder = 2
        Text = 'cxTextEdit2'
        Width = 180
      end
      object cxRichEdit1: TcxRichEdit
        Left = 10000
        Top = 10000
        Lines.Strings = (
          'cxRichEdit1')
        Style.BorderColor = clWindowFrame
        Style.BorderStyle = ebs3D
        TabOrder = 4
        Visible = False
        Height = 77
        Width = 203
      end
      object cxButton1: TcxButton
        Left = 10000
        Top = 10000
        Width = 72
        Height = 25
        Caption = 'cxButton1'
        TabOrder = 5
        Visible = False
      end
      object cxButton2: TcxButton
        Left = 10000
        Top = 10000
        Width = 72
        Height = 25
        Caption = 'cxButton2'
        TabOrder = 6
        Visible = False
      end
      object cxButton3: TcxButton
        Left = 10000
        Top = 10000
        Width = 72
        Height = 25
        Caption = 'cxButton3'
        TabOrder = 7
        Visible = False
      end
      object lcPreview_Root: TdxLayoutGroup
        AlignHorz = ahClient
        AlignVert = avClient
        CaptionOptions.Visible = False
        Visible = False
        ButtonOptions.Buttons = <>
        Hidden = True
        ShowBorder = False
        object lcPreviewGroup4: TdxLayoutGroup
          CaptionOptions.Text = 'New Group'
          LayoutLookAndFeel = dxLayoutWebLookAndFeel1
          ButtonOptions.Buttons = <>
          ShowBorder = False
          UseIndent = False
          object liWarning: TdxLayoutItem
            CaptionOptions.Text = 
              'This preview is built using editors shipped with the ExpressEdit' +
              'ors Library. We recommend that you use our editors to avoid pain' +
              'ting issues with standard VCL editors.'
            CaptionOptions.Glyph.Data = {
              36100000424D3610000000000000360000002800000020000000200000000100
              2000000000000010000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000001515
              155D262626B2282828CA252525CA232323CA202020CA1D1D1DCA191919CA1818
              18CA151515CA121212CA111111CA0E0E0ECA0C0C0CCA0A0A0ACA080808CA0606
              06CA050505CA020202CA020202CA000000CA000000CA000000CA000000CA0000
              00CA000000CA000000CA000000CA000000B20000005D00000000101010403838
              38E83B3B3BFF373737FF343434FF313131FF2D2D2DFF292929FF252525FF2222
              22FF1F1F1FFF1B1B1BFF191919FF161616FF121212FF101010FF0D0D0DFF0B0B
              0BFF080808FF060606FF040404FF020202FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000E800000040343434BC4343
              43FF404040FF3C3C3CFF363332FF302927FF2C2523FF29221FFF251D1BFF221A
              18FF1F1714FF1B1310FF18100DFF140C09FF120A06FF0F0703FF0C0400FF0900
              00FF070000FF050000FF020000FF000000FF000000FF000000FF000000FF0000
              00FF000000FF000000FF000000FF000000FF000000FF000000BC454545EA4848
              48FF454545FF3F3D3DFF70AABAFF86DBF3FF89E4FFFF85E2FFFF81E0FFFF7FDE
              FFFF7BDDFFFF79DCFFFF76DAFFFF73D9FFFF71D7FFFF6FD6FFFF6CD4FFFF6BD4
              FFFF68D3FFFF68D2FFFF67D1FFFF67D1FFFF67D0FFFF66D0FFFF66CFFFFF65CF
              FFFF63CBFAFF5492A5FF000000FF000000FF000000FF000000EA3F3F3FCA4C4C
              4CFF494949FF443F3DFF73B8C9FF63EEFFFF56E5FFFF52E3FFFF4CE0FFFF48DC
              FFFF43DAFFFF3ED8FFFF39D5FFFF34D3FFFF48DDFFFF4ED4FFFF4AD3FFFF3ED8
              FFFF21C9FFFF20C8FFFF20C7FFFF20C7FFFF1FC6FFFF1FC5FFFF1EC5FFFF1DC4
              FFFF25CBFFFF398FB6FF000000FF000000FF000000FF000000CA2222226B4F4F
              4FFF4C4C4CFF444140FF8EB4BDFF96F1FFFF74E2FFFF5FDDFFFF4FD8FFFF40D3
              FFFF3BCFFFFF38CEFFFF31CAFFFF48D4FFFF559DB7FF2D3A3FFF2A373CFF4D98
              B5FF35CBFFFF14BAFFFF16BAFFFF15B9FFFF14B8FFFF14B7FFFF13B6FFFF10B5
              FFFF1EC2FFFF3582A5FF000000FF000000FF000000FF0000006B0404040B5757
              57D5646464FF585756FF7A7E7FFFD4F7FCFFC2F5FFFFAFEEFFFF98EAFFFF79E1
              FFFF5AD9FFFF41D2FFFF37D1FFFF55C5ECFF32393CFF1F1714FF1B1310FF2831
              35FF44BCEAFF1BC0FFFF17BBFFFF17BAFFFF17B9FFFF16B9FFFF15B8FFFF11B7
              FFFF35C1FCFF1B333EFF000000FF000000FF000000D50000000B000000002C2C
              2C5C757575FF6E6E6EFF656363FFB0C6CCFFC9FCFFFFBAF2FFFFB3EFFFFFAAEC
              FFFF9BE9FFFF7EE2FFFF5BDDFFFF59C0E3FF303537FF24201EFF211C1AFF292D
              2FFF44B6E3FF1FC3FFFF1ABDFFFF18BBFFFF17BAFFFF17BAFFFF14B8FFFF1FC4
              FFFF3A8AAEFF040302FF030202FF020202FF0000005C00000000000000000303
              03085E5E5EC7747474FF696868FF818688FFCCF4FBFFBCF4FFFFB3F0FFFFABED
              FFFFA1EBFFFF98E9FFFF8BE5FFFF8CE8FDFF5C808DFF2C3031FF2A2D2EFF4B7C
              8DFF48D2FEFF1FC0FFFF1EBFFFFF1ABDFFFF18BBFFFF17BBFFFF13BBFFFF39C1
              FAFF1E343EFF050100FF050606FF020202C70000000800000000000000000000
              00002525254C797979FE737373FF6A6868FFADC2C6FFC8FCFFFFB7F1FFFFAFF0
              FFFFA5EDFFFF9BEAFFFF8FE7FFFF89E6FFFF91E8FFFF75BCD3FF5DB2CEFF54D5
              FFFF2EC9FFFF24C3FFFF22C2FFFF1EBFFFFF1ABDFFFF16BBFFFF23C7FFFF3C86
              A5FF0C0705FF0A0909FF080808FE0101014C0000000000000000000000000000
              0000000000005B5B5BB67A7A7AFF6F6F6EFF818687FFC9F1F9FFBCF5FFFFB3F1
              FFFFAAEFFFFF9FECFFFF95E9FFFF88E5FFFF8CF0FFFF6D929DFF537581FF4FD7
              FFFF2AC9FFFF2AC7FFFF26C5FFFF21C1FFFF1DBFFFFF16BFFFFF3DC1F5FF2536
              3CFF0E0A08FF0E0E0EFF060606B6000000000000000000000000000000000000
              0000000000001D1D1D397C7C7CFA797979FF6F6D6CFFACC0C5FFC7FCFFFFB5F2
              FFFFAEF0FFFFA4EDFFFF9AEBFFFF8FE8FFFF97F0FFFF5A6E73FF4A5558FF71DA
              FBFF38D0FFFF2EC9FFFF2AC7FFFF26C4FFFF1EC1FFFF2ACCFFFF4087A2FF160F
              0DFF141514FF101010FA03030339000000000000000000000000000000000000
              00000000000000000000545454A37F7F7FFF757474FF838788FFC8F0F6FFBCF5
              FFFFB2F1FFFFA9EFFFFF9FECFFFF95EDFFFF9AE3F6FF515C5FFF434748FF80D3
              ECFF55DBFFFF36CDFFFF2FCAFFFF2AC8FFFF23C7FFFF45C4F1FF2D3A3FFF1814
              12FF181818FF0C0C0CA300000000000000000000000000000000000000000000
              000000000000000000001616162B7D7D7DF17F7F7FFF747171FFABBFC3FFC6FB
              FFFFB5F2FFFFADF1FFFFA4EEFFFF9DF1FFFF9CD8E6FF484A4AFF3D3938FF80C1
              D4FF6BE3FFFF49D4FFFF34CEFFFF2DC9FFFF38D4FFFF4A89A0FF201916FF1F1F
              1FFF191919F10404042B00000000000000000000000000000000000000000000
              000000000000000000000000000050505094848484FF7C7B7AFF86898AFFC7EE
              F6FFBBF6FFFFB0F1FFFFA8EFFFFFA7F6FFFF93BFC9FF43403FFF403C3AFF739E
              AAFF7AE8FFFF59D9FFFF3ED2FFFF33D0FFFF53CAF1FF364145FF242120FF2323
              23FF121212940000000000000000000000000000000000000000000000000000
              00000000000000000000000000001010101D7D7D7DEB848484FF797877FFABBD
              C0FFC6FCFFFFB5F3FFFFACF1FFFFB1F9FFFF7E979CFF474444FF43403FFF6478
              7DFF87EDFFFF64DDFFFF4BD6FFFF4BDDFFFF558D9FFF2B2624FF2A2A2AFF2222
              22EB0303031D0000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000004545457C898989FF818080FF8B8E
              8EFFC6EEF5FFBAF6FFFFB0F2FFFFB8F8FFFF6E787AFF4B4948FF494645FF5962
              64FF8DE2F6FF6DE3FFFF57DEFFFF63D1F1FF414C4FFF312E2DFF2F2F2FFF1515
              157C000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000B0B0B147B7B7BDE898989FF7F7D
              7DFFADBFC2FFC6FCFFFFB6F7FFFFB4E8F2FF666B6CFF51504FFF4F4D4DFF5456
              56FF8ACEDEFF76E8FFFF71EAFFFF6196A3FF393331FF373737FF2C2C2CDE0303
              0314000000000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000003C3C3C698E8E8EFF8685
              85FF8D8F90FFC6EEF3FFBEFDFFFFB0DDE6FF646667FF565555FF545353FF5251
              4FFF88C3D1FF80F2FFFF83DAEEFF4C5457FF3D3A39FF3C3C3CFF161616690000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000005050509787878D28E8E
              8EFF848181FFADBEC2FFC8FEFFFFBEEEF5FF6F7475FF585656FF565454FF5C5E
              5FFF96D7E4FF90F6FFFF759DA6FF433E3DFF444444FF343434D2020202090000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000343434599292
              92FF8B8A8AFF909292FFC6EBF2FFC9FFFFFFA5BFC3FF656565FF5F5E5DFF8DA9
              B0FFA5F8FFFF98DFEFFF5E6264FF4B4949FF484848FF17171759000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000030303067171
              71C2929292FF898786FFADBDC0FFC8FBFFFFC3FAFFFFB7E7EFFFB0E3EDFFAEF3
              FFFFA4F7FFFF86A5ABFF585553FF525252FF383838C201010106000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000002929
              2945939494FC909090FF929393FFC6E9EFFFBEF9FFFFB6F8FFFFAEF7FFFFA6F6
              FFFFA8E0EBFF6E7071FF616160FF555555FC1515154500000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00006A6A6AAF969696FF8E8C8CFFADBABDFFCAFCFFFFB9F5FFFFB1F4FFFFB6FA
              FFFF93A9ACFF6A6665FF686869FF3E3E3EAF0000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000020202035959595F8949494FF959595FFC7E8EDFFC0F9FFFFB9F9FFFFB7E4
              EBFF7C7E7DFF717070FF696969F8131313350000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000636363A09A9A9AFF918F8FFFADB9BBFFD0FFFFFFCAFFFFFF9EAF
              B2FF797676FF787878FF464646A0000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000019191928939393F0999898FF979797FFACB7B8FFA7B3B5FF8889
              89FF818181FF757575F012121228000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000005858588D9E9E9EFF989898FF908E8EFF8C8A8AFF8C8B
              8BFF878787FF4747478D00000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000001010101A8B8B8BDE9D9D9DFF989898FF949494FF9090
              90FF787878DE0D0D0D1A00000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000000000002A2A2A42939393EA9D9D9DFF989898FF8888
              88EA252525420000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000003C3C3C5F6F6F6FB56D6D6DB53838
              385F000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000}
            CaptionOptions.Width = 235
          end
        end
        object lcPreviewGroup2: TdxLayoutGroup
          AlignVert = avClient
          CaptionOptions.Text = 'New Group'
          ButtonOptions.Buttons = <>
          LayoutDirection = ldTabbed
          ShowBorder = False
          object dxLayoutGroup1: TdxLayoutGroup
            AlignHorz = ahClient
            AlignVert = avClient
            CaptionOptions.Text = 'Group1'
            ButtonOptions.Buttons = <>
            object lcPreviewGroup3: TdxLayoutGroup
              CaptionOptions.Text = 'Group4'
              ButtonOptions.Buttons = <>
              object lcPreviewItem1: TdxLayoutItem
                CaptionOptions.Text = 'cxTextEdit1'
                Control = cxTextEdit1
                ControlOptions.ShowBorder = False
              end
              object lcPreviewItem8: TdxLayoutItem
                CaptionOptions.Text = 'cxTextEdit2'
                Control = cxTextEdit2
                ControlOptions.ShowBorder = False
              end
            end
            object lcPreviewItem2: TdxLayoutItem
              CaptionOptions.Text = 'cxCheckBox3'
              CaptionOptions.Visible = False
              Control = cxCheckBox3
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Group2: TdxLayoutGroup
            AlignVert = avClient
            CaptionOptions.Text = 'Group2'
            ButtonOptions.Buttons = <>
            object lcPreviewItem3: TdxLayoutItem
              AlignVert = avClient
              CaptionOptions.Text = 'cxRichEdit1'
              Control = cxRichEdit1
              ControlOptions.ShowBorder = False
            end
            object lcPreviewGroup5: TdxLayoutGroup
              AlignHorz = ahCenter
              CaptionOptions.Text = 'New Group'
              ButtonOptions.Buttons = <>
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object lcPreviewItem4: TdxLayoutItem
                CaptionOptions.Text = 'cxButton1'
                CaptionOptions.Visible = False
                Control = cxButton1
                ControlOptions.ShowBorder = False
              end
              object lcPreviewItem6: TdxLayoutItem
                CaptionOptions.Text = 'cxButton2'
                CaptionOptions.Visible = False
                Control = cxButton2
                ControlOptions.ShowBorder = False
              end
              object lcPreviewItem9: TdxLayoutItem
                CaptionOptions.Text = 'cxButton3'
                CaptionOptions.Visible = False
                Control = cxButton3
                ControlOptions.ShowBorder = False
              end
            end
          end
          object dxLayoutControl1Group3: TdxLayoutGroup
            AlignVert = avClient
            CaptionOptions.Text = 'Group3'
            ButtonOptions.Buttons = <>
            object lcPreviewItem5: TdxLayoutItem
              AlignVert = avClient
              CaptionOptions.Text = 'cxMemo1'
              Control = cxMemo1
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
    object lgRoot: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      object lcMainItem5: TdxLayoutItem
        CaptionOptions.Visible = False
        Control = tlbGroups
        ControlOptions.AutoColor = True
        ControlOptions.ShowBorder = False
      end
      object lcMainItem1: TdxLayoutItem
        AlignHorz = ahClient
        AlignVert = avClient
        Control = lbItems
      end
      object lcMainGroup3: TdxLayoutGroup
        CaptionOptions.Text = 'Preview'
        ButtonOptions.Buttons = <>
        object liPreview: TdxLayoutItem
          CaptionOptions.Text = 'lcPreview'
          CaptionOptions.Visible = False
          Control = lcPreview
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object lflMain: TdxLayoutLookAndFeelList
    Left = 256
    Top = 116
  end
  object alMain: TActionList
    Left = 8
    Top = 296
    object acAdd: TAction
      Category = 'Buttons'
      Caption = '&Add'
      Hint = 'Add'
      ImageIndex = 0
      OnExecute = btnAddClick
    end
    object acDelete: TAction
      Category = 'Buttons'
      Caption = '&Delete'
      Hint = 'Delete'
      ImageIndex = 1
      OnExecute = acDeleteExecute
    end
    object acClose: TAction
      Category = 'Buttons'
      Caption = '&Close'
      Hint = 'Close'
      ImageIndex = 2
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 32
  end
  object ilMain: TcxImageList
    CompressData = True
    FormatVersion = 1
    DesignInfo = 13631616
    ImageInfo = <
      item
        Image.Data = {
          920200005844424D020004023604850000424D36040000000000003600000028
          0000000210000000830100200000000000000400001900000000860000000400
          0000120000001D0000001F00000015000000050A00000000860000000F2E703C
          FF00550FFF00520FFF2A6739FF000000150A00000000860000001601590FFF3E
          9D53FF04811DFF00520FFF0000001F0A000000008600000015015C10FF57BC71
          FF069727FF00540FFF0000001F06000000008A00000002000000080000000E00
          00001100000022005F10FF59BF76FF089C2EFF00570FFF00000033020000001F
          82000000150000000502000000008E00000006378947FF016A10FF006810FF00
          6510FF01620FFF0DA73DFF0BA235FF005910FF005710FF005410FF00520FFF2A
          6739FF0000001502000000008E00000008017010FF47B86EFF2AC367FF14B952
          FF12B34BFF0FAD43FF0DA83DFF0BA135FF099C2EFF069727FF04811DFF00520F
          FF0000001F02000000008E00000006007210FF4ABE74FF63D692FF61D38EFF60
          D08AFF5ECB84FF0FAD43FF0DA73CFF59BF76FF58BC71FF409F55FF01540FFF00
          00001D02000000008E00000003358F45FF017211FF017011FF016D10FF016A10
          FF60CF8AFF12B34BFF006210FF015F10FF005B10FF015910FF296D39FF000000
          1202000000008E0000000100000003000000060000000800000011016E10FF62
          D38EFF14B852FF006410FF000000220000001500000016000000100000000406
          000000008600000008017011FF63D692FF29C367FF006810FF000000110A0000
          00008600000006017211FF4ABF74FF4ABB70FF006B10FF0000000E0A00000000
          8600000003358F45FF017311FF007010FF328642FF000000090A000000008600
          00000100000003000000060000000800000006000000021500000000}
      end
      item
        Image.Data = {
          9E0300005844424D020004023604850000424D36040000000000003600000028
          0000000210000000830100200000000000000400000700000000830000000100
          0000030000000104000000008300000001000000040000000105000000008500
          00000300000011040315480000000F0000000202000000008500000003000000
          1303031350000000190000000503000000008600000003000000140C0B41AA14
          136EFD06062478000000110200000002C600000014050522820E0D64FD080738
          B6000000210000000500000000000000010000000D0C0C42A6151573FF071EC9
          FF14136EFD0606247800000013000000140505237E0F0F67FD061BC7FF0E0D65
          FF080738B60000001800000001000000020504173F181675FA0B28CEFF0625DC
          FF071EC9FF121479FD0606247E06062480101174FD061BC7FF041DD8FF061BC5
          FF0E0D63FC0302134F0000000400000001000000080808286B181774FB0A28CE
          FF0525DCFF071ECAFF121479FE121378FE061BC7FF041DD8FF061BC6FF100E66
          FC0504227F00000012000000010000000000000001000000090808276A171A7E
          FB0A28CEFF0625DCFF061ECBFF061CCAFF041DD8FF061BC6FF101171FB050523
          7C000000120000000203000000008C000000010000000A0908286D171A7FFC09
          29CFFF0627DDFF0420DAFF061CC9FF121376FD0605247E000000120000000204
          000000008C00000001000000080908286A181B82FE0C2ED4FF072CE0FF0625DC
          FF071ECCFF121479FE0606247A000000110000000203000000008E0000000100
          00000609092A631A1E86FD0E3CDAFF0B39E7FF6379E3FF6175E0FF0625DCFF07
          1ECAFF121478FD060524740000000F000000020200000000AF000000030A0A2B
          5E1D1C7EFC1348DFFF0F49EFFF6580E7FF181B80FC161A7FFC6175DFFF0625DC
          FF071ECAFF14136FFD060624730000000C0000000100000000050413281E1E83
          FC4E7BEBFF1356F4FF6789EAFF191D84FA090828680808276A17197EFA6275DF
          FF0625DCFF071EC9FF14136EFD030210370000000200000000000000020E0D3A
          751F1E85FF88A7F1FF1B2087FA09092A6100000007000000080808286717197E
          FA6175DFFF161573FF090832870000000C00000001020000000085000000030E
          0D3A751C238CFA0A092B5D00000005020000000186000000070808286517197E
          FA0A0933820000000D0000000204000000008300000002040413270000000303
          000000008500000001000000050404112E00000008000000010D000000008100
          0000010400000000}
      end>
  end
  object ilMainDisabled: TcxImageList
    CompressData = True
    FormatVersion = 1
    DesignInfo = 13631672
    ImageInfo = <
      item
        Image.Data = {
          920200005844424D020004023604850000424D36040000000000003600000028
          0000000210000000830100200000000000000400001900000000860000000400
          0000120000001D0000001F00000015000000050A00000000860000000F2E703C
          FF00550FFF00520FFF2A6739FF000000150A00000000860000001601590FFF3E
          9D53FF04811DFF00520FFF0000001F0A000000008600000015015C10FF57BC71
          FF069727FF00540FFF0000001F06000000008A00000002000000080000000E00
          00001100000022005F10FF59BF76FF089C2EFF00570FFF00000033020000001F
          82000000150000000502000000008E00000006378947FF016A10FF006810FF00
          6510FF01620FFF0DA73DFF0BA235FF005910FF005710FF005410FF00520FFF2A
          6739FF0000001502000000008E00000008017010FF47B86EFF2AC367FF14B952
          FF12B34BFF0FAD43FF0DA83DFF0BA135FF099C2EFF069727FF04811DFF00520F
          FF0000001F02000000008E00000006007210FF4ABE74FF63D692FF61D38EFF60
          D08AFF5ECB84FF0FAD43FF0DA73CFF59BF76FF58BC71FF409F55FF01540FFF00
          00001D02000000008E00000003358F45FF017211FF017011FF016D10FF016A10
          FF60CF8AFF12B34BFF006210FF015F10FF005B10FF015910FF296D39FF000000
          1202000000008E0000000100000003000000060000000800000011016E10FF62
          D38EFF14B852FF006410FF000000220000001500000016000000100000000406
          000000008600000008017011FF63D692FF29C367FF006810FF000000110A0000
          00008600000006017211FF4ABF74FF4ABB70FF006B10FF0000000E0A00000000
          8600000003358F45FF017311FF007010FF328642FF000000090A000000008600
          00000100000003000000060000000800000006000000021500000000}
      end
      item
        Image.Data = {
          9E0300005844424D020004023604850000424D36040000000000003600000028
          0000000210000000830100200000000000000400000700000000830000000100
          0000030000000104000000008300000001000000040000000105000000008500
          00000300000011040315480000000F0000000202000000008500000003000000
          1303031350000000190000000503000000008600000003000000140C0B41AA14
          136EFD06062478000000110200000002C600000014050522820E0D64FD080738
          B6000000210000000500000000000000010000000D0C0C42A6151573FF071EC9
          FF14136EFD0606247800000013000000140505237E0F0F67FD061BC7FF0E0D65
          FF080738B60000001800000001000000020504173F181675FA0B28CEFF0625DC
          FF071EC9FF121479FD0606247E06062480101174FD061BC7FF041DD8FF061BC5
          FF0E0D63FC0302134F0000000400000001000000080808286B181774FB0A28CE
          FF0525DCFF071ECAFF121479FE121378FE061BC7FF041DD8FF061BC6FF100E66
          FC0504227F00000012000000010000000000000001000000090808276A171A7E
          FB0A28CEFF0625DCFF061ECBFF061CCAFF041DD8FF061BC6FF101171FB050523
          7C000000120000000203000000008C000000010000000A0908286D171A7FFC09
          29CFFF0627DDFF0420DAFF061CC9FF121376FD0605247E000000120000000204
          000000008C00000001000000080908286A181B82FE0C2ED4FF072CE0FF0625DC
          FF071ECCFF121479FE0606247A000000110000000203000000008E0000000100
          00000609092A631A1E86FD0E3CDAFF0B39E7FF6379E3FF6175E0FF0625DCFF07
          1ECAFF121478FD060524740000000F000000020200000000AF000000030A0A2B
          5E1D1C7EFC1348DFFF0F49EFFF6580E7FF181B80FC161A7FFC6175DFFF0625DC
          FF071ECAFF14136FFD060624730000000C0000000100000000050413281E1E83
          FC4E7BEBFF1356F4FF6789EAFF191D84FA090828680808276A17197EFA6275DF
          FF0625DCFF071EC9FF14136EFD030210370000000200000000000000020E0D3A
          751F1E85FF88A7F1FF1B2087FA09092A6100000007000000080808286717197E
          FA6175DFFF161573FF090832870000000C00000001020000000085000000030E
          0D3A751C238CFA0A092B5D00000005020000000186000000070808286517197E
          FA0A0933820000000D0000000204000000008300000002040413270000000303
          000000008500000001000000050404112E00000008000000010D000000008100
          0000010400000000}
      end>
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    object dxLayoutWebLookAndFeel1: TdxLayoutWebLookAndFeel
      GroupOptions.Color = clInfoBk
      ItemOptions.CaptionOptions.TextColor = clInfoText
    end
  end
end
