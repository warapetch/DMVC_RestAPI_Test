object WebMain: TWebMain
  OnCreate = WebModuleCreate
  OnDestroy = WebModuleDestroy
  Actions = <>
  AfterDispatch = WebModuleAfterDispatch
  Height = 230
  Width = 415
  PixelsPerInch = 96
end
