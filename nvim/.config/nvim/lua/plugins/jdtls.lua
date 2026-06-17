-- Configuration is from MariaSolOs's dotfiles:
-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/plugin/jdtls.lua

local root_markers = {
  {
    -- Multi-module projects
    "mvnw", -- Maven
    "gradlew", -- Gradle
    "settings.gradle", -- Gradle
    "settings.gradle.kts", -- Gradle
    -- Use git directory as last resort for multi-module maven projects
    -- In multi-module maven projects it is not really possible to determine what is the parent directory
    -- and what is submodule directory. And jdtls does not break if the parent directory is at higher level than
    -- actual parent pom.xml so propagating all the way to root git directory is fine
    ".git",
  },
  {
    -- Single-module projects
    "build.xml", -- Ant
    "pom.xml", -- Maven
    "build.gradle", -- Gradle
    "build.gradle.kts", -- Gradle
  },
}

return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    -- Only enable on Mac for now
    if vim.uv.os_uname().sysname ~= "Darwin" then
      return
    end

    local bundles = vim.fn.glob(
      "$XDG_DATA_HOME/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
      false,
      true
    )

    local function start_jdtls()
      local cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx4g",
        "-XX:+UseG1GC",
        "-XX:+UseStringDeduplication",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.glob(vim.env.HOMEBREW_PREFIX .. "/opt/jdtls/libexec/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        vim.env.HOMEBREW_PREFIX .. "/opt/jdtls/libexec/config_mac_arm",
      }

      -- Add lombok support if the jar is available in the expected location
      local lombok_jar = vim.fn.expand("$XDG_DATA_HOME/java/lombok.jar")
      if vim.fn.filereadable(lombok_jar) == 1 then
        table.insert(cmd, 2, "-javaagent:" .. lombok_jar)
      end

      -- Configure the data directory for the project
      local root_dir = vim.fs.root(0, root_markers)
      local project_name = root_dir and vim.fs.basename(root_dir)
      if project_name then
        vim.list_extend(cmd, {
          "-data",
          vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace",
        })
      end

      require("jdtls").start_or_attach({
        cmd = cmd,
        root_dir = root_dir,
        init_options = {
          bundles = bundles,
        },
        settings = {
          java = {
            inlayHints = {
              parameterNames = { enabled = "all" },
            },
            import = {
              exclusions = {
                "**/build/**",
                "**/.gradle/**",
                "**/node_modules/**",
                "**/.metadata/**",
                "**/bin/**",
                "**/out/**",
              },
            },
          },
        },
      })
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("junkaizhang8/jdtls_setup", { clear = true }),
      pattern = "java",
      callback = start_jdtls,
    })

    -- Attach to the buffer that triggered this load (the FileType autocmd
    -- above only fires for future java buffers)
    if vim.bo.filetype == "java" then
      start_jdtls()
    end
  end,
}
