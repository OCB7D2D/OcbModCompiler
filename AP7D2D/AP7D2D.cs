using System;
using System.Reflection;
using System.IO;
using Mono.Cecil;

namespace MOD7D2D
{
    class AP7D2D
    {

        static int Main(string[] args)
        {

            if (args.Length < 1)
            {
                Console.WriteLine("Mandatory managed game directory not given.");
                return 2;
            }

            string managedPath = Path.GetFullPath(args[0]);

            if (args.Length < 2)
            {
                Console.WriteLine("Mandatory output assembly not given.");
                return 2;
            }

            string outputPath = Path.GetFullPath(args[1]);

            var resolver = new DefaultAssemblyResolver();
            resolver.AddSearchDirectory(managedPath);
            string assemblyPath = managedPath + @"\Assembly-CSharp.dll";
            Console.WriteLine("Reading " + assemblyPath);
            AssemblyDefinition assembly = AssemblyDefinition.ReadAssembly(
                assemblyPath, new ReaderParameters { AssemblyResolver = resolver });

            for (int i = 2; i < args.Length; i++)
            {
                int lastBackslashPos = args[i].LastIndexOf('\\') + 1;
                string path = args[i].Substring(0, lastBackslashPos);
                string glob = args[i].Substring(lastBackslashPos,
                                args[i].Length - lastBackslashPos);

                foreach (var fname in Directory.GetFiles(path, glob))
                {
                    string fqpath = Path.GetFullPath(fname);
                    Console.WriteLine(" loading " + fqpath);
                    Assembly DLL = Assembly.LoadFile(fqpath);
                    foreach (TypeInfo type in DLL.GetTypes())
                    {
                        Type classType = DLL.GetType(type.FullName, true);
                        if (classType.GetMethod("Patch") is MethodInfo methodInfo)
                        {
                            object[] methodArguments = { assembly };
                            Console.WriteLine("  executing " + type.FullName + " patch");
                            methodInfo.Invoke(null, methodArguments);
                        }
                    }
                }
            }

            assembly.Write(outputPath);

            Console.WriteLine("Writing " + outputPath);

            return 0;
        }
    }
}
