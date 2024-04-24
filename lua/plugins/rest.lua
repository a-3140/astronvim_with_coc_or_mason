-- return {
--   {
--     "rest-nvim/rest.nvim",
--     ft = {"http", "https"},
--     dependencies = {
--       {
--         "nvim-treesitter/nvim-treesitter"
--       },
--       -- {
--       --   "vhyrro/luarocks.nvim",
--       --   branch = "go-away-python",
--       --   priority = 1000,
--       --   config = true,
--       -- },
--       {
--         "vhyrro/luarocks.nvim",
--         opts = {
--           rocks = {  "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }, -- Specify LuaRocks packages to install
--         },
--       },
--       {
--         "AstroNvim/astrocore",
--         opts = function(_, opts)
--           local maps = opts.mappings
--           local prefix = "<Leader>r"
--           maps.n[prefix] = { desc = "RestNvim" }
--           maps.n[prefix .. "r"] = { "<cmd>Rest run<cr>", desc = "Run request under the cursor" }
--           maps.n[prefix .. "l"] = { "<cmd>Rest run last<cr>", desc = "Re-run latest request" }
--         end,
--       },
--     },
--     main = "rest-nvim",
--   },
--   {
--     "nvim-treesitter/nvim-treesitter",
--     opts = function(_, opts)
--       if opts.ensure_installed ~= "all" then
--         opts.ensure_installed =
--           require("astrocore").list_insert_unique(opts.ensure_installed, { "lua", "xml", "http", "json", "graphql" })
--       end
--     end,
--   },
-- }
--
return {
  {
    "vhyrro/luarocks.nvim",
    branch = "go-away-python",
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }, -- Specify LuaRocks packages to install
    },
  },
  {
    "rest-nvim/rest.nvim",
    event = "VeryLazy",
    ft = { "http", "https" },
    dependencies = {
      {
        "luarocks.nvim",
        "nvim-lua/plenary.nvim",
      },
      {
        "folke/which-key.nvim",
        optional = true,
        opts = {
          defaults = {
            ["<leader>r"] = { name = "+rest" },
          },
        },
      },
    },
    config = function()
      require("rest-nvim").setup {
        keybinds = {},
        client = "curl",
        env_file = ".env",
        env_pattern = "\\.env$",
        env_edit_command = "tabedit",
        encode_url = true,
        skip_ssl_verification = false,
        custom_dynamic_variables = {}, logs = {
          level = "log",
          save = true,
        },
        result = {
          split = {
            horizontal = false,
            in_place = false,
            stay_in_current_window_after_split = true,
          },
          behavior = {
            decode_url = true,
            show_info = {
              url = true,
              headers = true,
              http_info = true,
              curl_command = true,
            },
            statistics = {
              enable = true,
              ---@see https://curl.se/libcurl/c/curl_easy_getinfo.html
              stats = {
                { "total_time", title = "Time taken:" },
                { "size_download_t", title = "Download size:" },
              },
            },
            formatters = {
              json = "jq",
              html = function(body)
                if vim.fn.executable "tidy" == 0 then return body, { found = false, name = "tidy" } end
                local fmt_body = vim.fn
                  .system({
                    "tidy",
                    "-i",
                    "-q",
                    "--tidy-mark",
                    "no",
                    "--show-body-only",
                    "auto",
                    "--show-errors",
                    "0",
                    "--show-warnings",
                    "0",
                    "-",
                  }, body)
                  :gsub("\n$", "")

                return fmt_body, { found = true, name = "tidy" }
              end,
            },
          },
          keybinds = {
            buffer_local = true,
            prev = "H",
            next = "L",
          },
        },
        highlight = {
          enable = true,
          timeout = 750,
        },
      }
      require("telescope").load_extension "rest"
    end,
    keys = {
      { "<leader>rr", "<cmd>Rest run<cr>", desc = "Run rest http request under cursor" },
      { "<leader>re", "<cmd>Telescope rest select_env<cr>", desc = "Select environment file for rest testing" },
    },
  },
}
