const { Model, DataTypes } = require('sequelize');


class Requisition extends Model {
    static init(sequelize) {
        super.init({
            order_id: DataTypes.INTEGER,
            status_id: DataTypes.INTEGER,
            priority: DataTypes.BOOLEAN,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        }, { sequelize });

    }
static associate(models){
this.belongsToMany(models.PartLocalization,{foreignKey:"requisition_id", through:"requisition_storages", as: "partlocalizations"});
this.belongsTo(models.Order,{foreignKey:'order_id', as: 'order'});
this.belongsTo(models.Status,{foreignKey:'status_id', as: 'status'});
this.hasMany(models.RequisitionStorage,{foreignKey:'requisition_id', as: 'requisitionStorages'});

}


}
module.exports = Requisition;