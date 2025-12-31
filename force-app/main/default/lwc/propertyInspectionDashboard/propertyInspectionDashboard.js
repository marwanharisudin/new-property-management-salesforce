import { LightningElement, api, wire } from 'lwc';
import getInspections from
    '@salesforce/apex/PropertyInspectionDashboardController.getInspections';
import getAverageRating from
    '@salesforce/apex/PropertyInspectionDashboardController.getAverageRating';
import { refreshApex } from '@salesforce/apex';

export default class PropertyInspectionDashboard extends LightningElement {

    @api recordId;

    inspections = [];
    averageRating;

    statusFilter = '';
    typeFilter = '';

    wiredInspectionResult;

    showFlow = false;

    /* OPTIONS */
    statusOptions = [
        { label: 'All', value: '' },
        { label: 'Completed', value: 'Completed' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Failed', value: 'Failed' }
    ];

    typeOptions = [
        { label: 'All', value: '' },
        { label: 'Annual', value: 'Annual' },
        { label: 'Safety', value: 'Safety' }
    ];

    /* DATA */
    @wire(getInspections, {
        accountId: '$recordId',
        statusFilter: '$statusFilter',
        typeFilter: '$typeFilter'
    })
    wiredInspections(result) {
        this.wiredInspectionResult = result;
        if (result.data) {
            this.inspections = result.data.map(row => ({
                ...row,
                statusClass: this.getStatusClass(
                    row.Inspection_Status__c
                )
            }));
        } else {
            this.inspections = [];
        }
    }

    @wire(getAverageRating, { accountId: '$recordId' })
    wiredAverage({ data }) {
        this.averageRating =
            data ? Number(data).toFixed(1) : null;
    }

    /* FILTER */
    handleStatusChange(e) {
        this.statusFilter = e.detail.value;
    }

    handleTypeChange(e) {
        this.typeFilter = e.detail.value;
    }

    /* FLOW HANDLER */
    get flowInputVariables() {
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId
            }
        ];
    }

    launchFlow() {
        this.showFlow = true;
    }

    closeFlow() {
        this.showFlow = false;
    }

    handleFlowStatus(event) {
        if (event.detail.status === 'FINISHED') {
            this.showFlow = false;
            this.refreshData();
        }
    }

    /* UTIL */
    getStatusClass(status) {
        switch (status) {
            case 'Completed':
                return 'slds-text-color_success';
            case 'In Progress':
                return 'slds-text-color_warning';
            case 'Failed':
                return 'slds-text-color_error';
            default:
                return '';
        }
    }

    refreshData() {
        refreshApex(this.wiredInspectionResult);
    }
}
