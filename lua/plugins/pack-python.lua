local utils = require "astrocore"
local is_available = require("astrocore").is_available
local set_mappings = require("astrocore").set_mappings

return {
  { "microsoft/python-type-stubs" },
  { "pandas-dev/pandas-stubs" },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      servers = { "pylsp" },
      ---@diagnostic disable: missing-fields
      config = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                mccabe = { enabled = false },
                -- formatter options
                black = { enabled = true },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = { enabled = true, executable = "pylint" },
                ruff = { enabled = false },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                -- type checker
                pylsp_mypy = {
                  enabled = true,
                  -- overrides = { "--python-executable", py_path, true },
                  report_progress = true,
                  live_mode = false
                },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                isort = { enabled = true },
              },
            }
          },
          on_attach = function(client, bufnr)
            if is_available "venv-selector.nvim" then
              set_mappings({
                n = {
                  ["<Leader>lv"] = {
                    "<cmd>VenvSelect<CR>",
                    desc = "Select VirtualEnv",
                  },
                  ["<Leader>lV"] = {
                    function()
                      require("astrocore").notify(
                        "Current Env:" .. require("venv-selector").get_active_venv(),
                        vim.log.levels.INFO
                      )
                    end,
                    desc = "Show Current VirtualEnv",
                  },
                },
              }, { buffer = bufnr })
            end
          end,
          filetypes = { "python" },
          root_dir = function(...)
            local util = require "lspconfig.util"
            return util.find_git_ancestor(...)
              or util.root_pattern(unpack {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "pyrightconfig.json",
              })(...)
          end,
          single_file_support = true,
          before_init = function(_, c) c.settings.python.pythonPath = vim.fn.exepath "python" end,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "python", "toml" })
      end
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "black", "isort", "mypy", "pylint" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "python" })
      if not opts.handlers then opts.handlers = {} end
      opts.handlers.python = function() end -- make sure python doesn't get set up by mason-nvim-dap, it's being set up by nvim-dap-python
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    opts = {
      anaconda_base_path = "~/miniconda3",
      anaconda_envs_path = "~/miniconda3/envs",
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
    config = function(_, opts)
      local path = require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/bin/python"
      require("dap-python").setup(path, opts)
    end,
  }
}
