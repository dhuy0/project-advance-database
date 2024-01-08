import express from "express";
import homeController from "../controller/homeController";
const router = express.Router();

/**
 *
 * @param {*} app : express app
 */

const initWebRoutes = (app) => {
  // GET METHOD--------------

  return app.use("/", router);
};

export default initWebRoutes;
