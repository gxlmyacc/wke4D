object MainForm: TMainForm
  Left = 75
  Top = 94
  Width = 977
  Height = 563
  Caption = 'Wke'#39029#38754#27979#35797
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 965
    Height = 528
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #39029#38754#21152#36733
      DesignSize = (
        957
        500)
      object EdtFilePath: TEdit
        Left = 166
        Top = 7
        Width = 654
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 4
        Text = 'index.html'
        OnKeyDown = EdtFilePathKeyDown
      end
      object Button1: TButton
        Left = 109
        Top = 5
        Width = 47
        Height = 25
        Caption = #21047#26032
        TabOrder = 3
        OnClick = Button1Click
      end
      object Panel1: TPanel
        Left = 0
        Top = 35
        Width = 953
        Height = 461
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 8
        TabStop = True
      end
      object Button4: TButton
        Left = -1
        Top = 5
        Width = 31
        Height = 25
        Caption = '<-'
        TabOrder = 0
        OnClick = Button4Click
      end
      object btnBrw: TButton
        Left = 823
        Top = 7
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 5
        OnClick = btnBrwClick
      end
      object Button7: TButton
        Left = 855
        Top = 7
        Width = 30
        Height = 21
        Anchors = [akTop, akRight]
        Caption = #24377#20986
        TabOrder = 6
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 891
        Top = 7
        Width = 63
        Height = 21
        Anchors = [akTop, akRight]
        Caption = #20851#38381#24377#20986
        TabOrder = 7
        OnClick = Button8Click
      end
      object Button9: TButton
        Left = 36
        Top = 5
        Width = 31
        Height = 25
        Caption = '->'
        TabOrder = 1
        OnClick = Button9Click
      end
      object Button10: TButton
        Left = 74
        Top = 5
        Width = 31
        Height = 25
        Caption = #20572#27490
        TabOrder = 2
        OnClick = Button10Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #32534#36753#22120
      ImageIndex = 1
      object Splitter1: TSplitter
        Left = 0
        Top = 191
        Width = 957
        Height = 3
        Cursor = crVSplit
        Align = alTop
      end
      object Panel2: TPanel
        Left = 0
        Top = 194
        Width = 957
        Height = 306
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 957
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Button2: TButton
          Left = 15
          Top = 5
          Width = 75
          Height = 25
          Caption = #26597#30475#25928#26524'(F9)'
          TabOrder = 0
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 102
          Top = 5
          Width = 101
          Height = 25
          Caption = #29992#27983#35272#22120#25171#24320'(F8)'
          TabOrder = 1
          OnClick = Button3Click
        end
        object Button5: TButton
          Left = 215
          Top = 5
          Width = 121
          Height = 25
          Caption = #25171#24320#31243#24207#24403#21069#30446#24405'(F7)'
          TabOrder = 2
          OnClick = Button5Click
        end
        object Button6: TButton
          Left = 345
          Top = 5
          Width = 86
          Height = 25
          Caption = #37325#32622#20026#27169#26495
          TabOrder = 3
          OnClick = Button6Click
        end
      end
      object SynMemo1: TSynMemo
        Left = 0
        Top = 41
        Width = 957
        Height = 150
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 1
        OnKeyDown = SynMemo1KeyDown
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.RightOffset = 18
        Gutter.ShowLineNumbers = True
        Gutter.Visible = False
        Gutter.Width = 0
        Highlighter = SynHTMLSyn1
        FontSmoothing = fsmNone
      end
    end
  end
  object XPManifest1: TXPManifest
    Left = 709
    Top = 30
  end
  object SynHTMLSyn1: TSynHTMLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 674
    Top = 29
  end
  object dlgOpen: TOpenDialog
    Filter = 'HTML'#25991#20214'(*.htm;*.html)|*.htm;*.html|'#25152#26377#25991#20214'(*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 869
    Top = 70
  end
  object FormStorage: TFormStorage
    StoredProps.Strings = (
      'EdtFilePath.Text'
      'SynMemo1.Lines')
    StoredValues = <>
    Left = 664
    Top = 104
  end
  object pmContext: TPopupMenu
    Left = 469
    Top = 129
    object miCopy: TMenuItem
      Caption = #22797#21046
      OnClick = miCopyClick
    end
    object miPaste: TMenuItem
      Caption = #31896#36148
      OnClick = miPasteClick
    end
    object miCut: TMenuItem
      Caption = #21098#20999
      OnClick = miCutClick
    end
    object miRedo: TMenuItem
      Caption = #37325#20570
      OnClick = miRedoClick
    end
    object miUndo: TMenuItem
      Caption = #25764#38144
      OnClick = miUndoClick
    end
  end
end
