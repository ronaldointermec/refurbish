const { addLog } = require("../logServices");
const connection = require("../database");
const Localization = require("../models/Localization");

module.exports = {
    async index(req, res) {
        addLog(
            "Dentro do INDEX",
            "INFO",
            "/localizations",
            req.params,
            null,
            "GET",
            req.headers,
            "Localization"
        );
        try {
            const { address } = req.params;
            let sqlLog;
            const localization = address
                ? await Localization.findOne({
                      logging: (value) => {
                          sqlLog = value;
                      },
                      attributes: ["id", "address"],
                      where: {
                          address,
                      },
                  })
                : await Localization.findAll({
                      logging: (value) => {
                          sqlLog = value;
                      },
                      attributes: ["id", "address"],
                  });

            addLog(
                "Sucesso na busca",
                "INFO",
                "/localizations",
                req.params,
                sqlLog,
                "GET",
                req.headers,
                "Localization"
            );
            return res.status(200).json(localization);
        } catch (err) {
            addLog(
                `Houve um erro ao carregar as localizações! Erro: ${err.message}`,
                "ERR",
                "/localizations",
                req.params,
                null,
                "GET",
                req.headers,
                "Localization"
            );
            return res
                .status(400)
                .json({ ERRO: `Erro recupear local!: ${err}` });
        }
    },

    async store(req, res) {
        addLog(
            "Dentro do STORE",
            "INFO",
            "/localizations",
            req.body,
            null,
            "POST",
            req.headers,
            "Localization"
        );
        try {
            const t = await connection.transaction();
            const { address, created_by } = req.body;
            let sqlLog;
            const localization = await Localization.create(
                {
                    address,
                    created_by,
                },
                {
                    logging: (value) => {
                        sqlLog = value;
                    },
                    transaction: t,
                }
            );
            await t.commit();
            addLog(
                "Sucesso na criação",
                "INFO",
                "/localizations",
                req.body,
                sqlLog,
                "POST",
                req.headers,
                "Localization"
            );
            return res.status(200).json(localization);
        } catch (err) {
            addLog(
                `Houve um erro ao criar a localização! Erro: ${err.message}`,
                "ERR",
                "/localizations",
                req.body,
                null,
                "POST",
                req.headers,
                "Localization"
            );
            return res
                .status(400)
                .json({ ERRO: `Erro ao salvar local!: ${err}` });
        }
    },
};
