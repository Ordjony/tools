$RootDirectory = $env:BUILD_SOURCESDIRECTORY
$ProjectFilters = "*.csproj"
$ProjectVersion = $env:GitVersion_SemVer

function Update-ProjectVersion([string]$projFilePath, [string]$version){
    $xml = [xml](Get-Content $projFilePath)
    $propGroup = $xml.Project.PropertyGroup

    if($propGroup.Version)
    {
        $propGroup.Version = $version
    }
    else{
        $verNode = $xml.CreateElement("Version")
        $verNode.InnerText = $version
        $propGroup.AppendChild($verNode)
    }

    $xml.Save($projFilePath)
}

$projectFiles = Get-ChildItem -Path $RootDirectory -Filter $ProjectFilters -Recurse
foreach($project in $projectFiles)
{
    Update-ProjectVersion -projFilePath $project.FullName -version $ProjectVersion
}