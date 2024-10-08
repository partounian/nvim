-- As defining all of the snippet-constructors (s, c, t, ...) in every file is rather cumbersome,
-- luasnip will bring some globals into scope for executing these files.
-- defined by snip_env in setup
require("luasnip.loaders.from_lua").lazy_load()
local env = snip_env

return {
  -- s("date", p(os.date, "%Y-%m-%d")),
  env.s(
    { trig = "gitlab_warn", name = "Gitlab warning", desc = "Warning emoji for Gitlab markdown" },
    env.fmta(
      [[
      :warning: <warn><finish>
      ]],
      {
        warn = env.i(1, "warning"),
        finish = env.i(0),
      }
    )
  ),
  env.s({ trig = "hugoimg", name = "Hugo image shortcut" }, {
    env.t("{{< img name="),
    env.i(1, { "name" }),
    env.t(" lazy="),
    env.i(2, { "true" }),
    env.t(" >}}"),
  }),
  env.s({ trig = "hugotoc", name = "Hugo toc", desc = "Hugo Table of Contents" }, {
    env.t("{{< toc >}}"),
  }),
  env.s({ trig = "hugosep", name = "Hugo separator", desc = "Separator in Hugo" }, {
    env.t("<!-- more -->"),
  }),
  env.s({ trig = "hugores", name = "Hugo resource", desc = "Hugo Resource entry" }, {
    env.t("\t- name: "),
    env.i(1, { "name", "" }),
    env.t("\t\tsrc: "),
    -- use value of node 1 but do not "overjump" it
    env.d(2, function(args)
      return env.sn(nil, { env.i(1), env.i(1, args[1]) })
    end, { 1 }),
    env.t("\t\ttitle: "),
    env.i(3, { "title" }),
  }),
  env.s(
    { trig = "hugoalert", name = "Alert", desc = "Alert shortcode of Blowfish theme" },
    env.fmta(
      [===[
      {{<< alert <opts> >>}}
      <text>
      {{<< /alert >>}}
      <finish>
      ]===],
      {
        opts = env.i(1),
        text = env.i(2),
        finish = env.i(0),
      }
    )
  ),
  env.s(
    { trig = "ltexLang", name = "Ltex language", desc = "Overwrite language for ltex LSP" },
    env.fmta(
      [[
      <<!-- LTeX: language=<lang> -->><finish>
      ]],
      {
        lang = env.i(1, "lang"),
        finish = env.i(0),
      }
    )
  ),
  env.s(
    { trig = "link", name = "Markdown link", desc = "A default Markdown link" },
    env.fmta(
      [[
      [<text>](<url>)<finish>
      ]],
      {
        text = env.i(1, "text"),
        url = env.i(2, "url"),
        finish = env.i(0),
      }
    )
  ),
  env.s(
    { trig = "chlog", name = "Changelog", desc = "Keep a changelog template" },
    env.fmt(
      [[
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2023-03-05

### Added

### Fixed

### Changed

### Removed

[unreleased]: https://github.com/olivierlacan/keep-a-changelog/compare/v1.1.1...HEAD
[0.0.3]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/olivierlacan/keep-a-changelog/releases/tag/v0.0.1
      ]],
      {}
    )
  ),
}
