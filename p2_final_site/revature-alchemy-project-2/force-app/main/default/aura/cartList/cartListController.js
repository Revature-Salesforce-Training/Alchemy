({
    // Gets order for orderId and updates the attribute
    getSingleOrder: function(component, event, helper) 
    {
        //console.log("In showing orders");

        var method = component.get("c.getOrder");
        //console.log('got method');

        method.setParams({orderId: component.get('v.currentOrderId')});
        //console.log('set parameter orderId as: ');
        //console.log(component.get("v.currentOrderId"));

        method.setCallback(this, function(response)
        {
            //console.log('in Callback of c.getOrder');
            if(response.getState() == "SUCCESS")
            {
                //console.log("In getOrder response, response is " + response.getReturnValue());
                component.set("v.currentOrder",  response.getReturnValue());
                console.log('testing set values');
                console.log(component.get("v.currentOrder"));//.ProductId_r.Image_URL__c)
                console.log('after set values');
            }
            else
            {
                console.log('error receieved from getOrders');
                console.log(response.getError());
            }
        });
        $A.enqueueAction(method);
    },

    handleMessage : function(component, event, helper)
    {
        console.log('received message from publish');
        if(event.getParam("orderId"))
        {
            component.set("v.currentOrderId", event.getParam("orderId"));
        }
    },
})