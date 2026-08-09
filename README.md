# marioolf.github.io

Personal portfolio and writing site built with Hugo.

## Quick workflow

Initialize the theme after cloning the repository:

```bash
make setup-theme
```

Create a new post as a page bundle:

```bash
make new-post TITLE="My New Post"
```

This creates `content/posts/my-new-post/index.md`, which makes it easier to keep screenshots and other assets next to the entry.

Run locally:

```bash
make serve
```

Build the site:

```bash
make build
```