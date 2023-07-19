module.exports = {
  dialect: "mssql",
  dialectModulePath: "msnodesqlv8/lib/sequelize",
  dialectOptions: {
    user: "",
    password: "",
    database: "node",
    options: {
      driver: "",
      // connectionString: "server=hic031801.honeywell.com\\SPS2K19P,1434; Database=REFURBISHPROD; Trusted_Connection=Yes; Driver={ODBC Driver 17 for SQL Server}",
      connectionString:
        "server=hic031801.honeywell.com\\SPS2K19P,1434; Database=REFURBISHPROD; Trusted_Connection=Yes; Driver={SQL Server Native Client 11.0}",
      trustedConnection: true,
      instanceName: "",
    },
  },
  define: {
    timestamps: true,
    underscored: true,
  },
  pool: {
    min: 0,
    max: 5,
    idle: 10000,
  },
};

// module.exports = {
//   dialect: "mssql",
//   //host: 'BR92LT97M37Z2',
//   host: "199.61.216.9",
//   port: "1434",
//   username: "refurbish",
//   password: "h^2+D<MZ!h@T63C4a8Z,[2A[m~rF.W4@",
//   database: "refurbish",
//   define: {
//     timestamps: true,
//     underscored: true,
//   },
// };

// const Sequelize = require("sequelize");

// const sequelize = new Sequelize({
//   dialect: "mssql",
//   dialectModulePath: "msnodesqlv8/lib/sequelize",
//   dialectOptions: {
//     user: "",
//     password: "",
//     database: "node",
//     options: {
//       driver: "",
//       connectionString:
//         "Driver={ODBC Driver 17 for SQL Server};Server=(localdb)\\node;Database=scratch;Trusted_Connection=yes;",
//       trustedConnection: true,
//       instanceName: "",
//     },
//   },
//   pool: {
//     min: 0,
//     max: 5,
//     idle: 10000,
//   },
// });

// import { SqlClient } from "msnodesqlv8";
// const sql: SqlClient = require("msnodesqlv8");
// //const connectionString = "server=.; Database=refurbish; Trusted_Connection=Yes; Driver={SQL Server Native Client 11.0}";
// const connectionString =
//   "server=hic031801.honeywell.com\\SPS2K19P,1434; Database=REFURBISHPROD; Trusted_Connection=Yes; Driver={SQL Server Native Client 11.0}";
// const query = "SELECT * FROM shipments";

// sql.query(connectionString, query, (err, rows) => {
//   console.log(rows);
// });
