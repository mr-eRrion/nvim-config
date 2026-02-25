local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local typst = require("util.typst")

-- Helper to create a simple autosnippet guarded to Typst math
local function greek_snip(trig, out)
  return s(
    { trig = trig, snippetType = "autosnippet", wordTrig = true },
    t(out),
    { condition = typst.in_math }
  )
end

local snippets = {}

-- Lowercase (24)
local lower = {
  al = "alpha",
  be = "beta",
  ga = "gamma",
  de = "delta",
  ep = "epsilon",
  ze = "zeta",
  et = "eta",
  th = "theta",
  io = "iota",
  ka = "kappa",
  la = "lambda",
  mu = "mu",
  nu = "nu",
  xi = "xi",
  oc = "omicron",
  pi = "pi",
  rh = "rho",
  si = "sigma",
  ta = "tau",
  up = "upsilon",
  ph = "phi",
  ch = "chi",
  ps = "psi",
  om = "omega",
}

-- Lowercase variants
local lower_variants = {
  vbe = "beta.alt",
  vep = "epsilon.alt",
  vth = "theta.alt",
  vka = "kappa.alt",
  vph = "phi.alt",
  vpi = "pi.alt",
  vrh = "rho.alt",
  vsi = "sigma.alt",
}

-- Uppercase (24)
local upper = {
  Al = "Alpha",
  Be = "Beta",
  Ga = "Gamma",
  De = "Delta",
  Ep = "Epsilon",
  Ze = "Zeta",
  Et = "Eta",
  Th = "Theta",
  Io = "Iota",
  Ka = "Kappa",
  La = "Lambda",
  Mu = "Mu",
  Nu = "Nu",
  Xi = "Xi",
  Oc = "Omicron",
  Pi = "Pi",
  Rh = "Rho",
  Si = "Sigma",
  Ta = "Tau",
  Up = "Upsilon",
  Ph = "Phi",
  Ch = "Chi",
  Ps = "Psi",
  Om = "Omega",
}

for trig, out in pairs(lower) do
  table.insert(snippets, greek_snip(trig, out))
end
for trig, out in pairs(lower_variants) do
  table.insert(snippets, greek_snip(trig, out))
end
for trig, out in pairs(upper) do
  table.insert(snippets, greek_snip(trig, out))
end

return snippets

