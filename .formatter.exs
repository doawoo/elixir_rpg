# Used by "mix format"
locals_without_parens = [member: 2, member: 3, name: 1, component: 1, component: 2, wants: 1]

[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens,
  import_deps: [:typed_struct]
]
