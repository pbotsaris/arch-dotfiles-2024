return {
	-- 1. Register Elixir/HEEx filetypes alongside standard web files
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"typescript",
		"react",
		"vue",
		"elixir",
		"eelixir",
		"heex",
	},

	root_markers = { "mix.exs", ".git", "tailwind.config.js", "package.json" },

	-- 3. Tell the LSP engine how to interpret Elixir files
	init_options = {
		userLanguages = {
			elixir = "html-eex",
			eelixir = "html-eex",
			heex = "html-eex",
		},
	},

	-- 4. Enable class scanning and autocomplete triggers for Phoenix templates
	settings = {
		tailwindCSS = {
			includeLanguages = {
				elixir = "html",
				eelixir = "html",
				heex = "html",
			},
			experimental = {
				classRegex = {
					-- Standard Phoenix/Elixir class styles
					[[class: "([^"]*)]],
					[[class: '([^\']*)]],
					[[class="([^"]*)]],
					-- Ultimate multi-line match for classes inside ~H sigils
					{ [[~H"""([^"]*)""", "class=\"([^\"]*)\""]] },
					{ [[~H"""(.*)""", "class=\"([^\"]*)\""]] },
				},
			},
		},
	},
}
