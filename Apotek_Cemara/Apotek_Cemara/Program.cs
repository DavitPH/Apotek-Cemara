using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace Apotek_Cemara
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Program pr = new Program();
            while (true)
            {
                try
                {
                    Console.WriteLine("Koneksi Ke Database");
                    Console.WriteLine("Maukkan User ID :");
                    string user = Console.ReadLine();
                    Console.WriteLine("Masukkan Password :");
                    string pass = Console.ReadLine();
                    Console.WriteLine("Masukkan Database Tujuan");
                    string db = Console.ReadLine();
                    Console.Write("\nKetik K untuk terhubung ke Database");
                    char chr = Convert.ToChar(Console.ReadLine());
                    switch (chr)
                    {
                        case 'K':
                            {
                                //Membuat koneksi
                                SqlConnection conn = null;
                                string strkoneksi = "data source=MSI\\DAVITPH;" +
                                "initial catalog = {0};" +
                                "user ID = {1}; password = {2}";
                                conn = new SqlConnection(string.Format(strkoneksi, db, user, pass));

                                conn.Open();
                                Console.Clear();
                                while (true)
                                {
                                    try
                                    {
                                        Console.WriteLine("\nMenu");
                                        Console.WriteLine("1. Melihat seluruh Data");
                                        Console.WriteLine("2. Tambah Data");
                                        Console.WriteLine("3. Keluar");
                                        Console.Write("\nEnter your choice (1-3): ");
                                        char ch = Convert.ToChar(Console.ReadLine());
                                        switch (ch)
                                        {
                                            case '1':
                                                {
                                                    Console.Clear();
                                                    Console.WriteLine("DATA PEMBELIAN\n");
                                                    Console.WriteLine();
                                                    pr.baca(conn);
                                                }
                                                break;
                                            case '2':
                                                {
                                                    Console.Clear();
                                                    Console.WriteLine("INPUT DATA PEMBELIAN\n");
                                                    Console.WriteLine("Masukkan ID Transaksi :");
                                                    string idtr = Console.ReadLine();
                                                    Console.WriteLine("Masukkan ID Pembeli :");
                                                    string idpl = Console.ReadLine();
                                                    Console.WriteLine("Masukkan ID Pegawai :");
                                                    string idpg = Console.ReadLine();
                                                    Console.WriteLine("Masukkan ID Obat : ");
                                                    string ido = Console.ReadLine();
                                                    Console.WriteLine("Masukkan Jumlah Pembelian : ");
                                                    string jml = Console.ReadLine();
                                                    Console.WriteLine("Masukkan Tanggal Transaksi : ");
                                                    string tgl = Console.ReadLine();
                                                    Console.WriteLine("Masukkan Total Bayar : ");
                                                    string ttl = Console.ReadLine();
                                                    try
                                                    {
                                                        pr.insert(idtr, idpl, idpg, ido, jml, tgl, ttl, conn);
                                                    }
                                                    catch
                                                    {
                                                        Console.WriteLine("\nAnda tidak memiliki akses untuk menambah data");
                                                    }
                                                }
                                                break;
                                            case '3':
                                                conn.Close();
                                                return;
                                            default:
                                                {
                                                    Console.Clear();
                                                    Console.WriteLine("\nInvalid Option");
                                                }
                                                break;

                                        }
                                    }
                                    catch
                                    {
                                        Console.WriteLine("\nCheck for the value entered.");
                                    }
                                }
                            }
                        default:
                            {
                                Console.WriteLine("\nInvalid Option");
                            }
                            break;
                    }
                }
                catch
                {
                    Console.Clear();
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine("Tidak dapat mengakses database menggunakan user tersebut\n");
                    Console.ResetColor();
                }
            }
        }

        public void baca(SqlConnection con)
        {
            SqlCommand cmd = new SqlCommand("Select * from dbo.Pembelian", con);
            SqlDataReader r = cmd.ExecuteReader();
            while (r.Read())
            {
                for (int i = 0; i < r.FieldCount; i++)
                {
                    Console.WriteLine(r.GetValue(i));
                }
                Console.WriteLine();
            }
            r.Close();

        }

        public void insert(string idtr, string idpl, string idpg, string ido, string jml, string tgl, string ttl, SqlConnection con)
        {
            string str = "";
            str = "insert into dbo.Pembelian (ID_Transaksi, ID_Pembeli, ID_Pegawai, ID_Obat, Jumlah_Pembelian, Tanggal_Transaksi, Total_Bayar)"
                + "values(@ID_Transaksi,@ID_Pembeli,@ID_Pegawai,@ID_Obat,@Jumlah_Pembelian,@Tanggal_Transaksi,@Total_Bayar)";
            SqlCommand cmd = new SqlCommand(str, con);
            cmd.CommandType = System.Data.CommandType.Text;

            cmd.Parameters.Add(new SqlParameter("ID Transaksi", idtr));
            cmd.Parameters.Add(new SqlParameter("ID_Pembeli", idpl));
            cmd.Parameters.Add(new SqlParameter("ID_Pegawai", idpg));
            cmd.Parameters.Add(new SqlParameter("ID_Obat", ido));
            cmd.Parameters.Add(new SqlParameter("Jumlah_Pembelian", jml));
            cmd.Parameters.Add(new SqlParameter("Tanggal_Transaksi", tgl));
            cmd.Parameters.Add(new SqlParameter("Tital_Bayar", ttl));
            cmd.ExecuteNonQuery();
            Console.WriteLine("Data Berhasil Ditambahkan");
        }
    }
}