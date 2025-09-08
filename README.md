# Svelte Effect Nix Template

This is a Nix-powered [Svelte](https://svelte.dev) template with [Effect](https://effect.website) integration. It builds an app fully reproducibly, including tests.

To quickly get started with this template, run:

```bash
mkdir project
cd project
nix flake init -t github:cor/svelte-effect-nix-template
git init
```

## Building and Running

### Building the App

To build the app, run:

```bash
nix build .#app
```

This will:

1. Install all dependencies
2. Build the application
3. Run tests using `vitest`
4. Output the build artifact to `./result`

### Previewing the App

To preview the built app in a browser, run:

```bash
nix run .#app-preview
```

This will:

1. Build the app if it hasn't been built already
2. Start a local server using `miniserve`
3. Serve the app on http://localhost:8080

The preview server uses SPA mode, so client-side routing will work correctly.

## Development

### Development Server

To start the development server with hot reloading:

```bash
nix run .#app-dev
```

This will install dependencies and start the Svelte development server.

### Development Shell

To enter a development shell with all necessary tools:

```bash
nix develop
```

This provides:

- Node.js and npm
- TypeScript language server
- Svelte language server
- Tailwind CSS language server
- Other development tools

### Formatting Code

Format all code in the project with:

```bash
nix fmt
```

This uses:

- Prettier to format TypeScript, JavaScript, JSON, Markdown, Svelte, HTML, and CSS files according to the project's configuration in `.prettierrc`
- nixpkgs-fmt to format Nix files
