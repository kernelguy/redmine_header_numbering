# Automatic Header Numbering Plugin

A clean and lightweight Redmine plugin that adds optional hierarchical section numbering to headers in Wiki pages,
Issue descriptions, and Journal notes/comments.

This plugin is fully compatible with **Redmine 6.0+** and **Rails 7.2+** using the modern **Zeitwerk** autoloader.

## Features

- **Optional Activation:** Only triggers on pages where you explicitly place the `{{number_headers}}` macro.
- **Hierarchical Numbering:** Automatically converts standard Markdown headers (e.g., `## Header`, `### Subheader`) into numbered sections (e.g., `## 1 Header`, `### 1.1 Subheader`).
- **Full Cross-Feature Support:** Works flawlessly in Wiki pages, Issue descriptions, and Journal comments.
- **Preview Support:** Works in real-time inside the "Preview" tab before saving your changes.
- **TOC Integration:** Automatically syncs with the built-in `{{toc}}` (Table of Contents) macro, ensuring your generated index matches the section numbers perfectly.
- **Safe Execution:** Processes content dynamically on-the-fly without altering or corrupting the raw data inside your database.
- **PDF export:** The header numbering is automatically applied to PDF exports.
- **Omitted from text export:** The header numbering is NOT included in the plain text export.

## Requirements

- Redmine >= 6.0-stable
- Rails >= 7.2
- Ruby >= 3.2

## Installation

1. Navigate to your Redmine plugins directory:
   ```bash
   cd /path/to/redmine/plugins
   ```

2. Clone this repository into a folder named exactly `redmine_header_numbering`:
   ```bash
   git clone https://github.com redmine_header_numbering
   ```

3. Restart your Redmine application server (e.g., Puma, Passenger, Thin):
   ```bash
   # Example for Puma environment
   touch /path/to/redmine/tmp/restart.txt
   ```

## Usage

Simply add the `{{number_headers}}` macro anywhere inside your Wiki text, Issue description, or Comment.

### Example Markdown Input

```markdown
# Document Title
{{number_headers}}

{{toc}}

## Introduction
This level 2 header will become section 1.

### Background
This level 3 header will become section 1.1.

## Main Content
This level 2 header will become section 2.
```

### Rendered Output (and Table of Contents)

```text
Table of Contents
Document Title
1 Introduction
  1.1 Background
2 Main Content

Document Title
1 Introduction
This level 2 header will become section 1.

1.1 Background
This level 3 header will become section 1.1.

2 Main Content
This level 2 header will become section 2.
```

*Note: Level 1 headers (`# Title`) are traditionally reserved for main document titles and are skipped by the numbering
processor.*

## How it works under the hood

Unlike other CSS solutions, this plugin hooks directly into `Redmine::WikiFormatting.singleton_class` using modern Ruby
module prepending. It intercepts the raw text sent into the Markdown processor, executes regex-based hierarchy
calculation, and passes the numbered text onto Redmine.

## Known Issues
 
- The preview cannot currently detect if the `{{number_headers}}` macro is present in the given content. Instead, it
relies on the last saved content to determine the numbering state.

## Future Roadmap

- Option to toggle level 1 header skipping.
- Support for Roman numerals (`I, II, III`) and Alphabetical prefixes (`A, B, C`).

## License

This plugin is released under the [MIT License](LICENSE).
