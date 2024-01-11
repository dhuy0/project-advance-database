import express from "express";
import homeController from "../controller/homeController";
const router = express.Router();

/**
 *
 * @param {*} app : express app
 */

const initWebRoutes = (app) => {
  // GET METHOD--------------
  router.get("/get-dentist-list", homeController.handleGetAllDentist)
  router.get("/get-patient-list", homeController.handleGetAllPatient)
  // POST METHOD--------------
  router.post("/add-patient", homeController.handleAddPatient)
  return app.use("/", router);
};

export default initWebRoutes;
