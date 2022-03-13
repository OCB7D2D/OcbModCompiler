using System;
using System.Reflection;
using System.IO;
using Mono.Cecil;

namespace MOD7D2D
{
    class AP7D2D
    {

        private static string ManagedPath;

        private static Assembly Resolver(object sender, ResolveEventArgs args)
        {
            var parts = args.Name.Split(",");
            var fqdn = ManagedPath + "\\" + parts[0] + ".dll";
            Console.WriteLine("Resolving: " + fqdn);
            var assemby = Assembly.LoadFile(fqdn);
            Console.WriteLine("  resolved: " + assemby);
            return assemby;
        }

        static int Main(string[] args)
        {

            AppDomain domain = AppDomain.CurrentDomain;

            domain.AssemblyResolve += new ResolveEventHandler(Resolver);

            if (args.Length < 1)
            {
                Console.WriteLine("Mandatory managed game directory not given.");
                return 2;
            }

            ManagedPath = Path.GetFullPath(args[0]);

            if (args.Length < 2)
            {
                Console.WriteLine("Mandatory output assembly not given.");
                return 2;
            }

            string outputPath = Path.GetFullPath(args[1]);

            var resolver = new DefaultAssemblyResolver();
            resolver.AddSearchDirectory(ManagedPath);
            string assemblyPath = ManagedPath + @"\Assembly-CSharp.dll";
            Console.WriteLine("Reading " + assemblyPath);
            AssemblyDefinition assembly = AssemblyDefinition.ReadAssembly(
                assemblyPath, new ReaderParameters { AssemblyResolver = resolver });
            Console.WriteLine("  read " + assembly);

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

            Console.WriteLine("Writing " + outputPath);

            assembly.Write(outputPath);

            Console.WriteLine("  written " + assembly);

            return 0;
        }
    }
}
