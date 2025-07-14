return {
  "bullets-vim/bullets.vim",
  init = function()
    vim.g.bullets_set_mappings = 0
    vim.g.bullets_delete_last_bullet_if_empty = 1
    vim.g.bullets_custom_mappings = {
      { "imap", "<CR>", "<Plug>(bullets-newline)" },
      { "inoremap", "<C-CR>", "<CR>" },

      { "nmap", "o", "<Plug>(bullets-newline)" },

      { "vmap", "gN", "<Plug>(bullets-renumber)" },
      { "nmap", "gN", "<Plug>(bullets-renumber)" },

      -- Custom checkbox toggle key
      { "nmap", "<M-x>", "<Plug>(bullets-toggle-checkbox)" },

      { "imap", "<C-t>", "<Plug>(bullets-demote)" },
      { "nmap", ">>", "<Plug>(bullets-demote)" },
      { "vmap", ">", "<Plug>(bullets-demote)" },

      { "imap", "<C-d>", "<Plug>(bullets-promote)" },
      { "nmap", "<<", "<Plug>(bullets-promote)" },
      { "vmap", "<", "<Plug>(bullets-promote)" },
    }
  end,
}
