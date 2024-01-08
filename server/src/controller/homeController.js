const { MAX } = require("mssql");
const { conn, sql } = require("../connect.js");

function convertDateFormat(inputDate) {
  // Sử dụng phương thức split để tách ngày, tháng, năm
  const dateParts = inputDate.split("-");

  // Sắp xếp lại các thành phần theo định dạng mới
  const formattedDate = dateParts.join("/");

  return formattedDate;
}

function stringToDate(inputDate) {
  var doo = new Date(inputDate);
  var formattedDate = new Date(
    doo.getTime() + Math.abs(doo.getTimezoneOffset() * 60000)
  );
  return formattedDate;
}

const handleGetInfoGameByDate = async (req, res) => {
  try {
    const date = req.params.date;
    var pool = await conn;
    var sqlString = `SELECT * FROM TranDau WHERE Ngay = @varDate`;
    const result = await pool
      .request()
      .input("varDate", sql.Date, date)
      .query(sqlString);
    console.log(result);
    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset);
    } else {
      res.status(500).json({ message: "đã có lỗi xảy ra" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleGetRankingInfoGameByDate = async (req, res) => {
  try {
    const date = new Date(req.params.date);
    var pool = await conn;
    var check = `SELECT QuyTacXepHang FROM QuyDinh`;
    const checkSQL = await pool.request().query(check);
    console.log(">>>> check sql: ", checkSQL.recordset[0]["QuyTacXepHang"]);
    var sortColumn = checkSQL.recordset[0]["QuyTacXepHang"];
    var sqlString = `SELECT db.MaDoiBong, db.TenDoiBong,  db.SoTranThang, db.SoTranHoa, db.SoTranThua, db.HieuSo, DENSE_RANK() OVER(ORDER BY ${sortColumn} DESC) Hang
                      FROM DoiBong db JOIN TranDau td ON db.TenDoiBong = td.TenDoi1 OR db.TenDoiBong = td.TenDoi2
                      WHERE td.Ngay = @varDate`;
    const result = await pool
      .request()
      .input("varDate", sql.Date, date)
      .query(sqlString);
    console.log(result);
    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset);
    } else {
      res.status(500).json({ message: "đã có lỗi xảy ra" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

module.exports = {};
