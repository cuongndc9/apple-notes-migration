goodbye coding 👋
# Apple Notes to Notion Migration Script

Export Apple Notes to Markdown files.

## Features

- Create a ZIP archive (wrap all Markdown files) in the Desktop folder

## Prerequisites

- macOS
- Apple Notes app
- Permission for Terminal to access Apple Notes

## Usage

1. Open Terminal
2. Run:
   ```bash
   yes | /bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/cuongndc9/apple-notes-migration/main/run.sh)"
   ```

## Importing to Notion

1. Open Notion
2. Click "Import"
3. Upload the ZIP file
4. Wait a moment and reload Notion page
5. All done 👏

## Troubleshooting

- Ensure Terminal has permission to access Apple Notes

## Limitations

- No attachments (images, PDFs)
- Basic text formatting only

## Contributing

Submit issues and enhancement requests on the GitHub repository!


<!-- INSPIRATIONAL_QUOTE_START -->
> "Don't be afraid to give up the good to go for the great." - John D. Rockefeller
<!-- INSPIRATIONAL_QUOTE_END -->
