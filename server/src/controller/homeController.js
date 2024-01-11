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

const handleGetScheduleByPatient = async (req, res) => {
  try {
    var patient = req.params.patient;
    var pool = await conn;
    var sqlString = `SELECT * FROM LICHHEN WHERE MABENHNHAN = @varPatient`;
    const result = await pool
      .request()
      .input("varPatient", sql.Char(6), patient)
      .query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleGetScheduleByRoom = async (req, res) => {
  try {
    var room = req.params.room;
    var pool = await conn;
    var sqlString = `SELECT * FROM LICHHEN WHERE PHONG = @varRoom`;
    const result = await pool
      .request()
      .input("varRoom", sql.Char(6), room)
      .query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleGetScheduleByDentist = async (req, res) => {
  try {
    var dentist = req.params.dentist;
    var pool = await conn;
    var sqlString = `SELECT * FROM LICHHEN WHERE NHASI = @varDentist`;
    const result = await pool
      .request()
      .input("varDentist", sql.Char(6), dentist)
      .query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleGetAllStaff = async (req, res) => {
  try {
    var pool = await conn;
    var sqlString = `SELECT * FROM NHANVIEN`;
    const result = await pool.request().query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleGetAllDentist = async (req, res) => {
  try {
    var pool = await conn;
    var sqlString = `SELECT * FROM NHASI`;
    const result = await pool.request().query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleGetAllMedicine = async (req, res) => {
  try {
    var pool = await conn;
    var sqlString = `SELECT * FROM THUOC`;
    const result = await pool.request().query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};
// Xem lai csdl de insert
const handleAddSchedule = async (req, res) => {
  try {
    //  phai xu li thoi gian cua javascript
    const data = req.body;
    var pool = await conn;
    var sqlString = `INSERT INTO LICHHEN(THOIGIAN, NHASI, MABENHNHAN, GHICHU, TINHTRANG, THOIGIANYEUCAU, PHONG, NGAYHENYEUCAU)
      VALUES(@varTime, @varDentist, @varPatient, @varNote, @varStatus, @varTimeRequest, @varRoom, @varDateRequest)`;
    const result = await pool
      .request()
      .input("varTime", sql.Time, data.THOIGIAN)
      .input("varDentist", sql.Char(6), data.NHASI)
      .input("varPatient", sql.Char(6), data.MABENHNHAN)
      .input("varNote", sql.NVarChar(50), data.GHICHU)
      .input("varStatus", sql.NVarChar(50), data.TINHTRANG)
      .input("varTimeRequest", sql.Time, data.THOIGIANYEUCAU)
      .input("varRoom", sql.Char(6), data.PHONG)
      .input("varDateRequest", sql.Date, data.NGAYHENYEUCAU)
      .query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleDeleteSchedule = async (req, res) => {
  try {
    const id = req.params.id;
    var pool = await conn;
    var sqlString = `DELETE FROM LICHHEN WHERE MALICHHEN = @varId`;
    const result = await pool
      .request()
      .input("varId", sql.Char(6), id)
      .query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleUpdateSchedule = async (req, res) => {
  try {
    //  phai xu li thoi gian cua javascript
    const data = req.body;
    var pool = await conn;
    var sqlString = `UPDATE LICHHEN 
    SET THOIGIAN = @varTime, NHASI = @varDentist, MABENHNHAN = @varPatient, GHICHU = @varNote,
    TINHTRANG = @varStatus, THOIGIANYEUCAU = @varTimeRequest, PHONG = @varRoom, NGAYHENYEUCAU = @varDateRequest
    WHERE MALICHHEN = @varId`;
    const result = await pool
      .request()
      .input("varTime", sql.Time, data.THOIGIAN)
      .input("varDentist", sql.Char(6), data.NHASI)
      .input("varPatient", sql.Char(6), data.MABENHNHAN)
      .input("varNote", sql.NVarChar(50), data.GHICHU)
      .input("varStatus", sql.NVarChar(50), data.TINHTRANG)
      .input("varTimeRequest", sql.Time, data.THOIGIANYEUCAU)
      .input("varRoom", sql.Char(6), data.PHONG)
      .input("varDateRequest", sql.Date, data.NGAYHENYEUCAU)
      .input("varId", sql.Char(6), data.MALICHHEN)
      .query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};
// Xem thu co store proc de add NHASI ko?
const handleAddDentist = async (req, res) => {
  // try {
  //   const data = req.body;
  //   var pool = await conn;
  //   var sqlString = `INSERT INTO NHASI(THOIGIAN, NHASI, MABENHNHAN, GHICHU, TINHTRANG, THOIGIANYEUCAU, PHONG, NGAYHENYEUCAU)
  //   VALUES(@varTime, @varDentist, @varPatient, @varNote, @varStatus, @varTimeRequest, @varRoom, @varDateRequest)`;
  //   const result = await pool
  //   .request()
  //   .input("varTime", sql.Time, data.THOIGIAN)
  //   .input("varDentist", sql.Char(6), data.NHASI)
  //   .input("varPatient", sql.Char(6), data.MABENHNHAN)
  //   .input("varNote", sql.NVarChar(50), data.GHICHU)
  //   .input("varStatus", sql.NVarChar(50), data.TINHTRANG)
  //   .input("varTimeRequest", sql.Time, data.THOIGIANYEUCAU)
  //   .input("varRoom", sql.Char(6), data.PHONG)
  //   .input("varDateRequest", sql.Date, data.NGAYHENYEUCAU)
  //   .input("varId", sql.Char(6), data.MALICHHEN)
  //   .query(sqlString);
  //   console.log(result);
  //   if (result.rowsAffected[0] > 0) {
  //     res.status(200).json(result.recordset[0]);
  //   } else {
  //     res.status(404).json({ message: "Không có dữ liệu" });
  //   }
  // } catch (error) {
  //   console.log(error);
  //   res.status(500).json({ message: error.message });
  // }
};
// Xem thu co store proc de Update NHASI ko?
const handleUpdateDentist = async (req, res) => {
  // try {
  //   const data = req.body;
  //   var pool = await conn;
  //   var sqlString = `INSERT INTO NHASI(THOIGIAN, NHASI, MABENHNHAN, GHICHU, TINHTRANG, THOIGIANYEUCAU, PHONG, NGAYHENYEUCAU)
  //   VALUES(@varTime, @varDentist, @varPatient, @varNote, @varStatus, @varTimeRequest, @varRoom, @varDateRequest)`;
  //   const result = await pool
  //   .request()
  //   .input("varTime", sql.Time, data.THOIGIAN)
  //   .input("varDentist", sql.Char(6), data.NHASI)
  //   .input("varPatient", sql.Char(6), data.MABENHNHAN)
  //   .input("varNote", sql.NVarChar(50), data.GHICHU)
  //   .input("varStatus", sql.NVarChar(50), data.TINHTRANG)
  //   .input("varTimeRequest", sql.Time, data.THOIGIANYEUCAU)
  //   .input("varRoom", sql.Char(6), data.PHONG)
  //   .input("varDateRequest", sql.Date, data.NGAYHENYEUCAU)
  //   .input("varId", sql.Char(6), data.MALICHHEN)
  //   .query(sqlString);
  //   console.log(result);
  //   if (result.rowsAffected[0] > 0) {
  //     res.status(200).json(result.recordset[0]);
  //   } else {
  //     res.status(404).json({ message: "Không có dữ liệu" });
  //   }
  // } catch (error) {
  //   console.log(error);
  //   res.status(500).json({ message: error.message });
  // }
};
// Xem thu co store proc ko?
const handleAddStaff = async (req, res) => {
  // try {
  //   const data = req.body;
  //   var pool = await conn;
  //   var sqlString = `INSERT INTO NHASI(THOIGIAN, NHASI, MABENHNHAN, GHICHU, TINHTRANG, THOIGIANYEUCAU, PHONG, NGAYHENYEUCAU)
  //   VALUES(@varTime, @varDentist, @varPatient, @varNote, @varStatus, @varTimeRequest, @varRoom, @varDateRequest)`;
  //   const result = await pool
  //   .request()
  //   .input("varTime", sql.Time, data.THOIGIAN)
  //   .input("varDentist", sql.Char(6), data.NHASI)
  //   .input("varPatient", sql.Char(6), data.MABENHNHAN)
  //   .input("varNote", sql.NVarChar(50), data.GHICHU)
  //   .input("varStatus", sql.NVarChar(50), data.TINHTRANG)
  //   .input("varTimeRequest", sql.Time, data.THOIGIANYEUCAU)
  //   .input("varRoom", sql.Char(6), data.PHONG)
  //   .input("varDateRequest", sql.Date, data.NGAYHENYEUCAU)
  //   .input("varId", sql.Char(6), data.MALICHHEN)
  //   .query(sqlString);
  //   console.log(result);
  //   if (result.rowsAffected[0] > 0) {
  //     res.status(200).json(result.recordset[0]);
  //   } else {
  //     res.status(404).json({ message: "Không có dữ liệu" });
  //   }
  // } catch (error) {
  //   console.log(error);
  //   res.status(500).json({ message: error.message });
  // }
};
// Xem thu co store proc ko?
const handleUpdateStaff = async (req, res) => {
  // try {
  //   const data = req.body;
  //   var pool = await conn;
  //   var sqlString = `INSERT INTO NHASI(THOIGIAN, NHASI, MABENHNHAN, GHICHU, TINHTRANG, THOIGIANYEUCAU, PHONG, NGAYHENYEUCAU)
  //   VALUES(@varTime, @varDentist, @varPatient, @varNote, @varStatus, @varTimeRequest, @varRoom, @varDateRequest)`;
  //   const result = await pool
  //   .request()
  //   .input("varTime", sql.Time, data.THOIGIAN)
  //   .input("varDentist", sql.Char(6), data.NHASI)
  //   .input("varPatient", sql.Char(6), data.MABENHNHAN)
  //   .input("varNote", sql.NVarChar(50), data.GHICHU)
  //   .input("varStatus", sql.NVarChar(50), data.TINHTRANG)
  //   .input("varTimeRequest", sql.Time, data.THOIGIANYEUCAU)
  //   .input("varRoom", sql.Char(6), data.PHONG)
  //   .input("varDateRequest", sql.Date, data.NGAYHENYEUCAU)
  //   .input("varId", sql.Char(6), data.MALICHHEN)
  //   .query(sqlString);
  //   console.log(result);
  //   if (result.rowsAffected[0] > 0) {
  //     res.status(200).json(result.recordset[0]);
  //   } else {
  //     res.status(404).json({ message: "Không có dữ liệu" });
  //   }
  // } catch (error) {
  //   console.log(error);
  //   res.status(500).json({ message: error.message });
  // }
};

const handleAddMedicine = async (req, res) => {
  try {
    const data = req.body;
    var pool = await conn;
    var sqlString = `INSERT INTO THUOC(TENTHUOC, GHICHU)
    VALUES(@varId, @varName, @varNote)`;
    const result = await pool
      .request()
      .input("varName", sql.NVarChar(50), data.TENTHUOC)
      .input("varNote", sql.NVarChar(50), data.GHICHU)
      .query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleDeleteMedicine = async (req, res) => {
  try {
    const id = req.params.id;
    var pool = await conn;
    var sqlString = `DELETE FROM THUOC WHERE MATHUOC = @varId`;
    const result = await pool
      .request()
      .input("varId", sql.Char(6), id)
      .query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

const handleUpdateMedicine = async (req, res) => {
  try {
    const data = req.body;
    var pool = await conn;
    var sqlString = `UPDATE THUOC 
    SET TENTHUOC = @varName, GHICHU = @varNote
    WHERE MATHUOC = @varId`;
    const result = await pool
      .request()
      .input("varName", sql.NVarChar(50), data.TENTHUOC)
      .input("varNote", sql.NVarChar(50), data.GHICHU)
      .input("varId", sql.Char(6), data.MATHUOC)
      .query(sqlString);

    console.log(result);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "Không có dữ liệu" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  handleGetScheduleByPatient,
  handleGetScheduleByRoom,
  handleGetScheduleByDentist,
  handleGetAllStaff,
  handleGetAllDentist,
  handleGetAllMedicine,
  handleAddSchedule,
  handleDeleteSchedule,
  handleUpdateSchedule,

  handleAddMedicine,
  handleDeleteMedicine,
  handleUpdateMedicine,
};
