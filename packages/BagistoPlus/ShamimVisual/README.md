# Shamim Visual Theme

**Shamim Visual** is a modified version of Bagisto's default **Velocity** theme, adapted to work seamlessly with [Bagisto Visual](https://github.com/bagistoplus/visual), the visual theme editor for Bagisto.

It preserves the core design and structure of the original Velocity theme while enabling visual customization through an intuitive editor interface.

## ✨ Features

- ✅ **Visual Editor Compatible**: Fully integrated with Bagisto Visual for no-code customization.
- ⚙️ **Based on Velocity**: Retains the familiar look and layout of Bagisto's default theme.
- 🎨 **Editable Layouts**: Update banners, content blocks, and homepage sections visually.

> [!NOTE]
> Currently, only the homepage and select theme settings (like fonts and colors) are editable. We plan to expand support to other pages such as category, product, and cart if the project gains interest

## 🌐 Live Demo

Check out the theme in action: [https://visual-debut-demo.bagistoplus.com](https://visual-debut-demo.bagistoplus.com?_previewMode=shamim-visual)

## 🚀 Getting Started

### 1. Install Bagisto Visual

Install and configure [Bagisto Visual](https://github.com/bagistoplus/visual) in your Bagisto project.

### 2. Install the theme via composer

```bash
composer require bagistoplus/shamim-visual
```

### 3. Publish Assets

```bash
php artisan vendor:publish --tag=shamim-visual-assets
```

### 4. Enable the Theme

Activate the theme in the admin panel.

## 🛠 Developer Notes

This theme includes updates to:

- Support dynamic homepage sections for visual editing
- Enable editable theme configuration (colors, fonts, etc.)
- Maintain Velocity’s original structure while adding customization layers

If you’ve customized Velocity before, the structure is exactly the same, but with with added support for visual editing layers.

## 🤝 Contributing

Found a bug or have ideas for new features? Open an issue or pull request on [GitHub](https://github.com/bagistoplus/shamim-visual).

## 👥 Credits

- Based on the original [Velocity Theme](https://github.com/bagisto/bagisto/tree/master/packages/Webkul/Shop)
- Visual integration by [Eldo Magan](https://github.com/eldomagan)
- [All Contributors](../../contributors)

## 📄 License

This project is open-sourced under the [MIT license](./LICENSE.md)
