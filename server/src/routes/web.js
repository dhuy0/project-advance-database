import express from "express";
import homeController from "../controller/homeController";
const router = express.Router();

/**
 *
 * @param {*} app : express app
 */

const initWebRoutes = (app) => {
  // GET METHOD--------------
  // Lấy các đội bóng có trong CSDL
  router.get("/get-all-team", homeController.handleGetAllTeam);
  //Lấy thông tin của đội bóng theo id
  router.get("/get-team-by-id/:teamId", homeController.handleGetTeamById);
  // Lấy thông tin tất cả cầu thủ
  router.get("/get-all-player", homeController.handleGetAllInfoPlayer);
  // Lấy thông tin cầu thủ theo tên
  router.get(
    "/get-player-by-name/:name",
    homeController.handleGetInfoPlayerByName
  );
  // Lấy thông tin cầu thủ theo tên đội bóng
  router.get(
    "/get-player-by-team/:teamName",
    homeController.handleGetInfoPlayerByTeam
  );
  // Lấy thông tin cầu thủ theo ngày -- đang làm
  router.get(
    "/get-player-by-date/:date",
    homeController.handleGetInfoPlayerByDate
  );
  // Lấy thông tin cầu thủ ghi bàn trong trận đấu theo ngày -- đang làm
  router.get(
    "/get-scorer-by-date/:date",
    homeController.handleGetScorerInfoPlayerByDate
  );
  // Lấy tất cả vòng đấu trong trận đấu
  router.get("/get-round-from-game", homeController.handleGetRoundFromGame);
  // Lấy vòng đấu trong trận đấu theo mã trận đấu
  router.get(
    "/get-round-from-game/:id",
    homeController.handleGetRoundFromGameId
  );
  // Lấy tên đội bóng trong DoiBong
  router.get("/get-name-team", homeController.handleGetTeamName);
  // Lấy tất cả đội bóng trong bảng trận đấu
  router.get("/get-name-team-tournament", homeController.handleGetTeamNameTournament);
  // Lấy tên đội 1 và 2 theo vòng đấu trong trận đấu
  router.get(
    "/get-name-team/:round",
    homeController.handleGetTeamNameFromRound
  );
  // Lấy mã trận đấu trong tất cả trận đấu
  router.get("/get-info-game", homeController.handleGetInfoGame);
  // Lấy thông tin trận đấu theo vòng
  router.get("/get-info-game/:round", homeController.handleGetInfoGameByRound);
  // Lấy thông tin trận đấu theo mã và vòng
  router.get(
    "/get-info-game/:id/:round",
    homeController.handleGetInfoGameByRoundAndId
  );
  // Lấy quy định
  router.get("/get-rule", homeController.handleGetRule);
  // Lấy Mã trận đấu theo vòng đấu
  router.get(
    "/get-id-game-from-round/:round",
    homeController.handleGetIdGameFromRound
  );
  // Lấy cầu thủ ghi bàn và số bàn ghi theo ngày thi đấu
  router.get(
    "/get-info-game-from-date/:date",
    homeController.handleGetInfoGameByDate
  );
  // Lấy bảng xếp hạng theo ngày
  router.get(
    "/get-ranking-game-from-date/:date",
    homeController.handleGetRankingInfoGameByDate
  );
  // POST METHOD--------------
  // Thêm đội bóng và thành viên
  router.post("/reg", homeController.handleReg);
  // Thêm nhiều thành viên vô đội bóng
  router.post("/add-multi-player-to-team", homeController.handleAddMultiPlayer);
  // Thêm thành viên vô đội bóng
  router.post("/add-player-to-team", homeController.handleAddPlayerToTeam);
  // Thêm bàn thắng
  router.post("/add-scorer", homeController.handleAddScorer);
  // Thêm lịch thi đấu
  router.post("/add-schedule", homeController.handleAddSchedule);

  // PUT METHOD--------------
  // Thay đổi thông tin thành viên
  router.put("/update-player-team", homeController.handleUpdatePlayer);

  router.put(
    "/update-multi-player-team",
    homeController.handleUpdateMultiPlayer
  );
  // Thay đổi lịch đấu
  router.put("/update-schedule", homeController.handleUpdateSchedule);
  // Xác nhận kết quả trận đấu
  router.put("/update-record", homeController.handleUpdateRecord);
  // Thay đổi quy định
  router.put("/change-rule", homeController.handleUpdateRule);

  // DELETE METHOD--------------
  // Xóa thành viên ra đội bóng
  router.post("/delete-player-team", homeController.handleDeletePlayer);

  return app.use("/", router);
};

export default initWebRoutes;
