-- ══════════════════════════════════════════════════════════════════════════════
-- GitHub Copilot - AI-Powered Code Completion
-- Integrated with blink-cmp for seamless completion experience
-- ══════════════════════════════════════════════════════════════════════════════

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({})
  end,
}
