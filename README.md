# BepInEx preload patching for 7 days 2 die (A20)

This is still work in progress but already usable!

Inspired by https://github.com/SphereII/DMTBridgeLoaderPlugin

## Installation

Copy all files from `7 Days To Die` folder into your game folder.
If you install it for the first time, no file should be overwritten!
If you don't intend to create mods yourself, this should be all!

### What does it do

Enables in-memory patching for main game assembly `Assembly-CSharp.dll`.
This allows modders to add additional fields to existing classes, make
classes public or methods virtual to enable certain inheritance scenarios.

### How does it work

We use [BepInEx][1] to patch the main game assembly `Assembly-CSharp.dll`
before it is actually loaded by the Unity Game Engine. In order to do this,
BepInEx uses [Unity Doorstop][2]. It uses a trick as at least one Unity
dependency or library tries to load `winhttp.dll`. This file is normally
not there (which is sliently ignored), but once we put one in place, it
is loaded and initialized before the actual game dlls are loaded. At this
stage BepInEx will apply all preloader patchers from the Mods directory.
This happens all in memory, before Unity actually loads the game dll.
Unity then loads the in-memory changed versions of the game dll.

### Additional Tools for Developers/Modders

Once you add a new field to a class, you probably also want to use it.
The true dynamic approach would be to utilize a runtime FieldDefinition:

```csharp
FieldInfo field = AccessTools.Field(typeof(BaseClass), "CurrentSpoilage");
Klass currentSpoilage = (Klass) field.GetValue(__instance); // needs cast
field.SetValue(__instance, currentSpoilage);
```

This is a bit tedious and doesn't help with readability. It would be nice
if we could compile against the "in-memory" patched state directly. And
that seems actually possible, although more testing is required.

### Assembly Patcher Command-Line Utility

I create a very basic cli-utility to load the  `Assembly-CSharp.dll` file,
apply a given list of `patchers` and write the result to disk. You can then
use that patched assembly as reference to compile your code. You dont need
to deploy this patched dll, it's only needed to compile your mod.

```batch
AP7D2D [7D2D\Managed] [Output] [PatcherDLL1]...
AP7D2D "G:\steam\steamapps\common\7 Days To Die\7DaysToDie_Data\Managed" ^
"build\Assembly-CSharp.dll" "patchers\MyModPatch.dll"
```

### Additional batch utilities

In order to streamline the whole compilation, I created two additional
batch files that help with compiling the preloader patchers and the
final (harmony) module dll. Finally there is a wrapper script that
executes all necessary steps to compile your mod (similar to DMT).

- CM7D2D.bat is the main compiler utility
- Calls PC7D2D.bat to compile BepInEx preloader patcher dll
- Calls AP7D2D.exe to create a patched assembly-csharp dll
- Calls MC7D2D.bat to compile mod against patched assembly

```batch
CM7D2D [NAME] [SOURCES] [PATCHERS]
CM7D2D MyModName Harmony\*.cs PatchScripts\*.cs
```

Note that you can only pass one argument for sources and patchers, but that
argument can be one wildcard. Better argument passing might come in the future.
It should work ok if you stick each type into its own folder. Patcher dlls
must be placed in the `patchers` folder in order for BepInEx to find them.

#### Required environment variables

In order for the utilities to be available and globally callable, you need to
add the `utils` path to your global `path` environment variable (please see
google if you dont know how). Additionally we need one or two more environment
variables to be set (please adjust them accordingly):

```batch
PATH_7D2D_MANAGED=G:\steam\steamapps\common\7 Days To Die\7DaysToDie_Data\Managed
ROSLYN_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn
```

The `PATH_7D2D_MANAGED` must point to the managed data directory of your game install, as `AP7D2D`
will try to load the original `Assembly-CSharp.dll` from that location. Also other assemblies are
referenced from there during compilation. The `ROSLYN_PATH` is optional and points to where your
roslyn csharp compiler (csc.exe) is located (default path might just work fine).

#### Real-World A20 Example Modules

- https://github.com/OCB7D2D/ElectricityWireColors
- https://github.com/OCB7D2D/ElectricityOverhaul

[1]: https://github.com/BepInEx/BepInEx
[2]: https://github.com/NeighTools/UnityDoorstop