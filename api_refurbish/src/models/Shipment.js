const { Model, DataTypes } = require('sequelize');


class Shipment extends Model {
    static init(sequelize) {
        super.init({
            os: DataTypes.STRING,
            local: DataTypes.STRING,
            is_lab: DataTypes.BOOLEAN,
            status_id: DataTypes.INTEGER,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        }, { sequelize }

        );
    }
    static associate(models) {
        this.belongsTo(models.Status, { foreignKey: "status_id", as: 'status' });
    }
}

module.exports = Shipment;