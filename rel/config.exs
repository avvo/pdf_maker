~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"G1|O&_.!hqTTVrVdk$@TT3K==(JGiaU(.FXl&M^p,4.oa^8wjcs?b_p@3VfQksGH"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"vxJoGJ$eNCZ~YHgvq!8.y$!y;9[YdPK(t?/`5bL~|p1%T_`J]|xgjAzCt1g`1xTD"
  set vm_args: "rel/vm.args"
end

release :pdf_maker do
  set version: current_version(:pdf_maker)
  set applications: [
    :runtime_tools
  ]
end
