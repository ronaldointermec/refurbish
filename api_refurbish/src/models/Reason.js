const { Model, DataType, DataTypes } = require('sequelize');

class Reason extends Model {

    static init(sequelize) {
        super.init({
            description: DataTypes.STRING,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        }, { sequelize });
    }

    /* static associate(models){
        this.hasMany(models.RequisitionStorage,{foreignKey:'reason_id'})
    } */

}

module.exports = Reason;