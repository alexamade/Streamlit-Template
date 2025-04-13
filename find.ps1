param (
    # the dir is passed to script from cmd line
    [string]$directory,
    [string]$searchString
)

# Check the user input parameters above are provided if not error
if (-not $directory) {
    Write-Host "Please provide a directory path to search in."
    exit
}

# Get all files in the directory with error handling
try {
    $files = Get-ChildItem -Path $directory -Recurse -File -ErrorAction Stop
} catch {
    Write-Host "Error accessing directory: $_"
    exit
}

# Loop through each file and search for the string
foreach ($file in $files) {
    try {
        Select-String -Path $file.FullName -Pattern $searchString | ForEach-Object {
            [PSCustomObject]@{
                FilePath = $_.Path
                LineNumber = $_.LineNumber
                Line = $_.Line
            }
        }
    } catch {
        Write-Host "Error processing file: $file.FullName"
    }
}