const { Model, DataTypes } = require('sequelize');

class PartLocalization extends Model {

    static init(sequelize) {
        super.init({
            part_id: DataTypes.INTEGER,
            localization_id: DataTypes.INTEGER,
            status_id: DataTypes.INTEGER,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,

        }, { sequelize })

    }
    static associate(models) {
        this.belongsToMany(models.Requisition, { foreignKey: "partlocalization_id", through: "requisition_storages", as: "requisitions" });
        this.belongsTo(models.Part, { foreignKey: "part_id", as: 'parts' });
        this.belongsTo(models.Localization, { foreignKey: "localization_id", as: 'localizations' });
        this.belongsTo(models.Status, { foreignKey: "status_id", as: 'status' });
    }
}

module.exports = PartLocalization;