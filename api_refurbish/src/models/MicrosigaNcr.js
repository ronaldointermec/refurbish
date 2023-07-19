const { Model, DataTypes } = require('sequelize')

class MicrosigaNcr extends Model {

    static init(sequelize) {
        super.init({
            order_id: DataTypes.INTEGER,
            status_id: DataTypes.INTEGER,
            pn: DataTypes.STRING,
            quantidade: DataTypes.INTEGER,
            position: DataTypes.STRING,
            desc_pn: DataTypes.STRING,
            motivo: DataTypes.STRING,
            desc_problema: DataTypes.STRING,
            tipo: DataTypes.STRING,
            mov_microsiga: DataTypes.STRING,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        }, { sequelize }
        );
    }

    static associate(models) {
        this.belongsTo(models.Order, { foreignKey: 'order_id', as: 'order' });
        this.belongsTo(models.Status, { foreignKey: "status_id", as: 'status' });
    }

}

module.exports = MicrosigaNcr;

