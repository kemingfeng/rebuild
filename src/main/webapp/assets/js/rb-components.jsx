// ~~!v1.0 弹出窗口
class RbModal extends React.Component {
    constructor(props) {
        super(props);
        this.state = { ...props, inLoad: true };
        if (props.target) {
            let that = this;
            let t = $(props.target);
            t.click(function(){
                that.show({ url:t.data('url') })
            })
        }
    }
	render() {
		return (
			<div className="modal rbmodal colored-header colored-header-primary" ref="rbmodal">
		        <div className="modal-dialog">
    		        <div className="modal-content">
        		        <div className="modal-header modal-header-colored">
            		        <h3 className="modal-title">{this.state.title || ''}</h3>
            		        <button className="close md-close" type="button" onClick={()=>this.hide()}><span className="zmdi zmdi-close"></span></button>
            		    </div>
        		        <div className={'modal-body iframe rb-loading' + (this.state.inLoad ? ' rb-loading-active' : '')} ref="rbmodal.body">
            		        <iframe src={this.state.url || 'about:blank'} frameborder="0" scrolling="no" ref="rbmodal.iframe" onLoad={()=>this.loaded()} onResize={()=>this.loaded()}></iframe>
            		        <RbSpinner />
        		        </div>
    		        </div>
		        </div>
			</div>
		)
	}
	show(state) {
	    if (!!!state) {
	        $(this.refs['rbmodal']).modal({ show: true, backdrop: 'static' });
	    } else {
            let that = this;
            this.setState(state, function(){
                $(that.refs['rbmodal']).modal({ show: true, backdrop: 'static' });
            })
	    }
    }
    hide() {
        $(this.refs['rbmodal']).modal('hide');
    }
    loaded() {
        if (!this.state.url) return;
        let that = this;
        $setTimeout(function(){
            let iframe = $(that.refs['rbmodal.iframe']);
            let height = iframe.contents().find('body .main-content').height();
            if (height == 0) height = iframe.contents().find('body').height();
            else height += 45;  // .main-content's padding
            if (height == 0 || height == that.__lastHeight) return;
            $(that.refs['rbmodal.body']).height(height);
            that.__lastHeight = height;
            that.setState({ inLoad:false })
        }, 30, 'RbModal-resize');
    }
}

// ~~!v1.0 提示框
class RbAlter extends React.Component {
    constructor(props) {
       super(props);
       this.state = { ...props };
    }
    render() {
        return (
            <div className="modal rbalter" ref="rbalter">
                <div className="modal-dialog">
                    <div className="modal-content">
                        <div className="modal-header">
                            <button className="close" type="button" onClick={()=>this.hide()}><span className="zmdi zmdi-close"></span></button>
                        </div>
                        <div className="modal-body">
                            <div className="text-center">
                                <h3>提示</h3>
                                <p>{this.state.message || '提示内容'}</p>
                                <div class="mt-8">
                                    <button className="btn btn-secondary" type="button" ref="rbalter.confirm" onClick={()=>this.hide()}>确定</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
    show(message) {
        let that = this;
        this.setState({ message: message }, function(){
            $(that.refs['rbalter']).modal('show');
            $(that.refs['rbalter.confirm']).focus();
        })
    }
    hide() {
        $(this.refs['rbalter']).modal('hide');
    }
}

function RbSpinner(props) {
    return <div className="rb-spinner">
        <svg width="40px" height="40px" viewBox="0 0 66 66" xmlns="http://-www.w3.org/2000/svg">
            <circle fill="none" stroke-width="4" stroke-linecap="round" cx="33" cy="33" r="30" class="circle"></circle>
        </svg>
    </div>
}

const renderRbcomp = function(jsx) {
    let container = $('#react-comps');
    if (container.length == 0) container = $('<div id="react-comps"></div>').appendTo(document.body);
    return ReactDOM.render(jsx, container[0]);
};