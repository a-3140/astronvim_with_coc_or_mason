return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      -- Configuration table of features provided by AstroLSP
      autoformat = false, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      lsp_handlers = true, -- enable/disable setting of lsp_handlers
      semantic_tokens = true, -- enable/disable semantic token highlighting
      inlay_hints = false,
      diagnostics_mode = 3,
    },
    -- Configuration options for controlling formatting with language servers
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true,
      },
      -- disable formatting capabilities for specific language servers
      disabled = { "eslint", "volar" },
      -- default format timeout
      timeout_ms = 600000,
    },
    capabilities = {
      workspace = {
        didChangeWatchedFiles = { dynamicRegistration = true, relativePatternSupport = true },
      },
    },
    diagnostics = {
      underline = true,
      virtual_text = {
        spacing = 5,
        severity_limit = "WARN",
        severity = {
          min = vim.diagnostic.severity.WARN,
        },
      },
      signs = {
        severity = {
          min = vim.diagnostic.severity.WARN,
        },
      },
      update_in_insert = false,
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
      },
      i = {
        ["<C-l>"] = {
          function() vim.lsp.buf.signature_help() end,
          desc = "Signature help",
          cond = "textDocument/signatureHelp",
        },
      },
    },
  },
}
