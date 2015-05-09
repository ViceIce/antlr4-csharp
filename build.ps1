
param(
    [Alias("c")]
    [switch] $compatible
)

$msbuild = "C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe"

$out = Resolve-Path .

function Invoke-MSBuild {
param(
    $tfv,
    $const
)

$out = Join-Path $out ($tfv.Replace("v","bin/net").Replace(".",""))
$args = ("/nologo", "/m", "/v:m", "/t:Rebuild")

$args += "/p:Configuration=Release;TargetFrameworkVersion=$tfv;DefineConstants=`"$const`";OutputPath=$out\;SignAssembly=true;AssemblyOriginatorKeyFile=..\..\Antlr4.snk"

$args += "runtime\CSharp\Antlr4.Runtime\Antlr4.Runtime.vs2013.csproj"

& $msbuild $args
}


Invoke-MSBuild -tfv "v2.0" -const "TRACE;"
Invoke-MSBuild -tfv "v3.5" -const "TRACE;NET35PLUS"
Invoke-MSBuild -tfv "v4.0" -const "TRACE;NET35PLUS;NET40PLUS"
if ($compatible){
    Invoke-MSBuild -tfv "v4.5" -const "TRACE;NET35PLUS;NET40PLUS"
} else {
    Invoke-MSBuild -tfv "v4.5" -const "TRACE;NET35PLUS;NET40PLUS;NET45PLUS"
}