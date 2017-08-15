function Add-PowerLineBlock {
    <#
        .Synopsis
            Insert text or a ScriptBlock into the $Prompt
        .Description
            This function exists primarily to ensure that modules are able to modify the prompt easily without repeating themselves.
        .Example
            Add-PowerLineBlock { "`nI &hearts; PS" }

            Adds the classic "I ♥ PS" to your prompt on a new line. We actually recommend having a simple line in pure 16-color mode on the last line of your prompt, to ensures that PSReadLine won't mess up your colors. PSReadline overwrites your prompt line when you type -- and it can only handle 16 color mode.
        .Example
            Add-PowerLineBlock {
                New-PromptText { Get-Elapsed } -ForegroundColor White -BackgroundColor DarkBlue -ErrorBackground DarkRed -ElevatedForegroundColor Yellow
            } -Index -2

            # This example uses Add-PowerLineBlock to insert a block into the prommpt _before_ the last block
            # It calls Get-Elapsed to show the duration of the last command as the text of the block
            # It uses New-PromptText to control the color so that it's highlighted in red if there is an error, but otherwise in dark blue (or yellow if it's an elevated host).
    #>
    [CmdletBinding(DefaultParameterSetName="Error")]
    param(
        # The text, object, or scriptblock to show as output
        [Parameter(Position=0, Mandatory, ValueFromPipeline)]
        [Alias("Text")]
        $InputObject,

        # The position to insert the InputObject at, Defaults to -1 (to append at the end).
        [int]$Index = -1,

        # If set, adds the input to the prompt without checking if it's already there
        [Switch]$Force
    )
    process {
        Write-Debug "Add-PowerLineBlock $InputObject"
        if($Force -or !$Prompt.Contains($InputObject)) {
            if($Index -eq -1 -or $Index -gt $Prompt.Count) {
                Write-Verbose "Appending '$InputObject' to the end of the prompt"
                $Prompt.Add($InputObject)
            } elseif($Index -lt 0) {
                $Index = $Prompt.Count - $Index
                Write-Verbose "Inserting '$InputObject' at $Index of the prompt"
                $Prompt.Insert($Index, $InputObject)
            } else {
                Write-Verbose "Inserting '$InputObject' at $Index of the prompt"
                $Prompt.Insert($Index, $InputObject)
            }
        } else {
            Write-Verbose "Prompt already contained the InputObject block"
        }
    }
}