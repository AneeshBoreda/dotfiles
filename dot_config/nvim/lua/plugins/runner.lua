-- Project runner with hierarchical detection and per-project overrides
-- Detects nearest Cargo.toml or package.json, with optional .nvim-runner.lua override

local M = {}

-- Project type markers (checked in order, first match wins)
local markers = {
  { file = "Cargo.toml", type = "rust", run = "cargo run", build = "cargo build", test = "cargo test" },
  { file = "package.json", type = "node", run = "pnpm dev", build = "pnpm build", test = "pnpm test" },
}

-- Walk up from current file to find nearest project marker
function M.detect_project()
  local current = vim.fn.expand("%:p:h")

  while current ~= "/" and current ~= "" do
    for _, marker in ipairs(markers) do
      local marker_path = current .. "/" .. marker.file
      if vim.fn.filereadable(marker_path) == 1 then
        -- Check for override file at same level
        local override_path = current .. "/.nvim-runner.lua"
        local project = vim.deepcopy(marker)
        project.dir = current

        if vim.fn.filereadable(override_path) == 1 then
          local ok, override = pcall(dofile, override_path)
          if ok and type(override) == "table" then
            project.run = override.run or marker.run
            project.build = override.build or marker.build
            project.test = override.test or marker.test
          end
        end

        return project
      end
    end
    current = vim.fn.fnamemodify(current, ":h")
  end

  return nil
end

-- Shared float options (same as terminal.lua)
local float_opts = {
  win = {
    position = "float",
    backdrop = 60,
    height = 0.9,
    width = 0.9,
    zindex = 50,
    border = "rounded",
  },
}

-- Execute a project command
function M.exec(cmd_type)
  local project = M.detect_project()
  if not project then
    vim.notify("No project detected (looking for Cargo.toml or package.json)", vim.log.levels.WARN)
    return
  end

  local cmd = project[cmd_type]
  if not cmd then
    vim.notify("No " .. cmd_type .. " command for " .. project.type, vim.log.levels.WARN)
    return
  end

  -- Build the full command to run from project directory
  local full_cmd = "cd " .. vim.fn.shellescape(project.dir) .. " ; " .. cmd

  -- Get or create the shared floating terminal (same one used by <c-/>)
  local term = Snacks.terminal.get(nil, float_opts)
  
  -- Ensure terminal is visible
  if not term or not term:buf_valid() then
    -- Open a fresh terminal if none exists
    Snacks.terminal.toggle(nil, float_opts)
    term = Snacks.terminal.get(nil, float_opts)
  elseif not term:win_valid() then
    -- Show the terminal if hidden
    Snacks.terminal.toggle(nil, float_opts)
  end

  -- Send the command to the terminal
  if term and term:buf_valid() then
    vim.defer_fn(function()
      -- Send the command followed by Enter
      local chan = vim.bo[term.buf].channel
      if chan then
        vim.api.nvim_chan_send(chan, full_cmd .. "\n")
      end
    end, 100) -- Small delay to ensure terminal is ready
  end
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>rr", function() M.exec("run") end, desc = "Run Project" },
      { "<leader>rb", function() M.exec("build") end, desc = "Build Project" },
      { "<leader>rt", function() M.exec("test") end, desc = "Test Project" },
      { "<leader>ri", function()
        local project = M.detect_project()
        if project then
          vim.notify(
            string.format("Project: %s\nDir: %s\nRun: %s\nBuild: %s\nTest: %s",
              project.type, project.dir, project.run, project.build, project.test or "N/A"),
            vim.log.levels.INFO
          )
        else
          vim.notify("No project detected", vim.log.levels.WARN)
        end
      end, desc = "Project Info" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>r", group = "run" })
    end,
  },
}
