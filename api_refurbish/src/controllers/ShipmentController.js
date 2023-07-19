const Shipment = require("../models/Shipment");
const { Op } = require("sequelize");
const connection = require("../database");
const logService = require("../logServices");

module.exports = {
  async store(req, res) {
    const { os, local, is_lab, status_id, created_by } = req.body;
    logService.addLog(
      "store",
      "INFO",
      "/shipment",
      req.body,
      null,
      "POST",
      req.headers,
      "Shipment"
    );

    const t = await connection.transaction();
    try {
      let sqlLog;
      const [shipment, isNew] = await Shipment.findOrCreate({
        logging: (value) => {
          sqlLog = value;
        },
        where: { os, local, is_lab, status_id, created_by },
        transaction: t,
        // defaults:{}
      });

      if (isNew) {
        await t.commit();
        logService.addLog(
          "Sucesso ao alocar OS",
          "INFO",
          "/shipment",
          req.body,
          sqlLog,
          "POST",
          req.headers,
          "Shipment"
        );
        return res.status(200).json("Sucesso ao alocar!");
      } else {
        await t.commit();
        logService.addLog(
          "Já foi realizada alocação com um dos dados informados",
          "INFO",
          "/shipment",
          req.body,
          null,
          "POST",
          req.headers,
          "Shipment"
        );
        return res
          .status(202)
          .json("Já foi realizada alocação com um dos dados informados!");
      }
    } catch (err) {
      await t.rollback();
      logService.addLog(
        `Erro ao salvar OS: ${err}`,
        "INFO",
        "/shipment",
        null,
        null,
        "POST",
        req.headers,
        "Shipment"
      );
      return res.status(400).json({ ERROR: `Erro ao alocar!: ${err}` });
    }
  },

  async indexOS(req, res) {
    const { os } = req.body;
    logService.addLog(
      "indexOS",
      "INFO",
      "/shipmentConsultaOS",
      req.params,
      null,
      "POST",
      req.headers,
      "Shipment"
    );

    try {
      let sqlLog;
      const shipment = os
        ? await Shipment.findAll({
            logging: (value) => {
              sqlLog = value;
            },
            where: {
              os,
              //os: { [Op.substring]: os },
              is_lab: true,
            },
            order: [["updated_at", "DESC"]],
            limit: 1,
          })
        : await Shipment.findAll({
            logging: (value) => {
              sqlLog = value;
            },
            where: {
              is_lab: true,
              status_id: 2,
            },
            order: [["updated_at", "DESC"]],
            //limit: 1,
          });

      /* if (shipment === 0) {
                return res.status(400).json({ VALIDAÇÃO: 'Shipment não foi localizado' })
            } */
      logService.addLog(
        "OSs encontradas",
        "INFO",
        "/shipmentConsultaOS",
        req.params,
        sqlLog,
        "POST",
        req.headers,
        "Shipment"
      );
      return res.status(200).json(shipment);
    } catch (err) {
      logService.addLog(
        `Erro ao recuperar OSs!: ${err}`,
        "ERR",
        "/shipmentConsultaOS",
        null,
        null,
        "POST",
        req.headers,
        "Shipment"
      );
      return res.status(400).json({ ERROR: `Erro ao recuperar OSs!: ${err}` });
    }
  },

  async index(req, res) {
    const { os } = req.params;
    logService.addLog(
      "index",
      "INFO",
      "/shipment",
      req.params,
      null,
      "GET",
      req.headers,
      "Shipment"
    );

    try {
      let sqlLog;
      const shipment = !os
        ? await Shipment.findAll({
            logging: (value) => {
              sqlLog = value;
            },
            where: {
              is_lab: false,
              status_id: 2,
            },
            order: [["updated_at", "DESC"]],
          })
        : await Shipment.findAll({
            logging: (value) => {
              sqlLog = value;
            },
            where: {
              //os:{[Op.like]:os},
              os: { [Op.substring]: os },
              is_lab: false,
              status_id: 2,
            },
            order: [["updated_at", "DESC"]],
          });

      /*  if (shipment === 0) {
                 return res.status(400).json({ VALIDAÇÃO: 'Shipment não foi localizado' })
             } */

      logService.addLog(
        "OS encontradas",
        "INFO",
        "/shipment",
        req.params,
        sqlLog,
        "GET",
        req.headers,
        "Shipment"
      );
      return res.status(200).json(shipment);
    } catch (err) {
      logService.addLog(
        `Erro ao recuperar OSs!: ${err}`,
        "ERR",
        "/shipment",
        null,
        null,
        "GET",
        req.headers,
        "Shipment"
      );
      return res.status(400).json({ ERROR: `Erro ao recuperar OSs!: ${err}` });
    }
  },

  async update(req, res) {
    const { id, status_id, updated_by } = req.body;
    logService.addLog(
      "update",
      "INFO",
      "/shipment",
      req.body,
      null,
      "PATCH",
      req.headers,
      "Shipment"
    );

    const t = await connection.transaction();
    try {
      let sqlLog;
      const shipment = await Shipment.update(
        {
          status_id,
          updated_by,
        },
        {
          logging: (value) => {
            sqlLog = value;
          },
          where: {
            id,
          },
          transaction: t,
        }
      );

      await t.commit();
      logService.addLog(
        "Sucesso ao atualizar OS",
        "INFO",
        "/shipment",
        req.body,
        sqlLog,
        "PATCH",
        req.headers,
        "Shipment"
      );
      return res.status(200).json({ SUCESSO: "Sucesso ao atualizar OS!" });
    } catch (err) {
      await t.rollback();
      logService.addLog(
        `Erro ao atualizar OS: ${err}`,
        "INFO",
        "/shipment",
        null,
        null,
        "PATCH",
        req.headers,
        "Shipment"
      );
      return res.stutus(400).json({ ERRO: `Erro ao atualizar OS!: ${err}` });
    }
  },
};
