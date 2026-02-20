using System;
using System.Runtime.InteropServices;
using Microsoft.SqlServer.Server;

namespace SSFunction
{
    public class FunctionDefinitions
    {
        [DllImport(@"C:\rust_for_sqlserver\target\x86_64-pc-windows-msvc\release\rust_for_sqlserver.dll")]
        internal static extern IntPtr remove_numbers_c(string input);

        [DllImport(@"C:\rust_for_sqlserver\target\x86_64-pc-windows-msvc\release\rust_for_sqlserver.dll")]
        internal static extern void free_string(IntPtr ptr);

        [SqlFunction(DataAccess = DataAccessKind.Read)]
        public static string RemoveNumbersWithRust(string input)
        {
            if (input == null)
            {
                return null;
            }

            IntPtr ptr = remove_numbers_c(input);
            if (ptr == IntPtr.Zero)
            {
                return null;
            }

            try
            {
                string result = Marshal.PtrToStringAnsi(ptr);
                return result;
            }
            finally
            {
                free_string(ptr); // Call this here to free the memory
            }
        }
    }
}