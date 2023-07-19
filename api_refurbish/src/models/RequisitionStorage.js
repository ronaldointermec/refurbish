const { Model, DataTypes } = require('sequelize');

class RequisitionStorage extends Model {

    static init(sequelize) {
        super.init({
            partlocalization_id: DataTypes.INTEGER,
            requisition_id: DataTypes.INTEGER,
            reason_id: DataTypes.INTEGER,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,

        }, { sequelize });
    }

    static associate(models) {
        this.belongsTo(models.PartLocalization, { foreignKey: 'partlocalization_id', as:'partlocalizations'}),
        this.belongsTo(models.Requisition, { foreignKey: 'requisition_id' });
        this.belongsTo(models.Reason, { foreignKey: "reason_id", as: 'reasons' });
    }

}

module.exports = RequisitionStorage;
