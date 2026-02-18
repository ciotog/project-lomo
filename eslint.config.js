import antfu from "@antfu/eslint-config";

export default antfu({
	formatters: true,
	react: true,
	stylistic: {
		indent: "tab",
		quotes: "double",
		semi: true,
	},
	ignores: [
		"docs/_site/",
		"dist/",
		"vendor/",
		"*.min.js",
	],
});
