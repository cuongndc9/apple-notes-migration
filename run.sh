#!/bin/bash

# Configuration - modify these paths as needed
NOTES_DIR="$HOME/Desktop/apple-notes-migration" # Temporary directory for markdown files
OUTPUT_DIR="$HOME/Desktop" # Where the final zip file will be saved
DATE_STAMP=$(date +"%Y%m%d_%H%M%S")
ZIP_NAME="apple_notes_$DATE_STAMP.zip"

# Create export directory if it doesn't exist
mkdir -p "$NOTES_DIR"

# Function to sanitize filenames
sanitize_filename() {
    echo "$1" | sed 's/[^a-zA-Z0-9._-]/_/g'
}

# Export notes from Apple Notes using AppleScript
echo "Exporting notes from Apple Notes..."
osascript <<EOD
tell application "Notes"
    set allNotes to every note
    repeat with currentNote in allNotes
        try
            set noteTitle to name of currentNote
            if noteTitle is missing value then set noteTitle to "Untitled Note"
            set noteContent to body of currentNote
            if noteContent is missing value then set noteContent to ""
            set createDate to creation date of currentNote
            set modDate to modification date of currentNote
            
            -- Format dates
            try
                set createDateStr to do shell script "date -j -f '%a %b %d %H:%M:%S %Y' " & quoted form of (createDate as string) & " +'%Y-%m-%d %H:%M:%S'"
            on error
                set createDateStr to "Unknown Date"
            end try
            try
                set modDateStr to do shell script "date -j -f '%a %b %d %H:%M:%S %Y' " & quoted form of (modDate as string) & " +'%Y-%m-%d %H:%M:%S'"
            on error
                set modDateStr to "Unknown Date"
            end try
            
            -- Prepare the markdown content
            set mdContent to "---\ntitle: " & noteTitle & "\ncreated: " & createDateStr & "\nmodified: " & modDateStr & "\n---\n\n" & noteContent
            
            -- Create sanitized filename
            set sanitizedTitle to do shell script "echo " & quoted form of noteTitle & " | sed 's/[^a-zA-Z0-9._-]/_/g'"
            set fileName to "${NOTES_DIR}/" & sanitizedTitle & ".md"
            
            -- Write to file
            do shell script "echo " & quoted form of mdContent & " > " & quoted form of fileName
            
            log "Exported: " & noteTitle
            
        on error errMsg
            log "Error processing note: " & errMsg
        end try
    end repeat
end tell
EOD

# Check if any files were created
if [ -z "$(ls -A "$NOTES_DIR")" ]; then
    echo "No notes were exported. Please check if you have any notes or if the script has proper permissions."
    exit 1
fi

# Create zip archive
echo "Creating zip archive..."
cd "$OUTPUT_DIR"
if ! zip -r "$ZIP_NAME" "$(basename "$NOTES_DIR")"; then
    echo "Error creating zip file"
    exit 1
fi

# Cleanup
echo "Cleaning up temporary files..."
rm -rf "$NOTES_DIR"

echo "Export complete! Your notes have been exported to: $OUTPUT_DIR/$ZIP_NAME"
echo "You can now manually import this zip file into Notion."
