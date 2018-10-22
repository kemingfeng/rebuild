//~~ 视图
class RbViewForm extends React.Component {
    constructor(props) {
        super(props)
        this.state = { ...props }
    }
    render() {
        return (
            <div className="rbview-form" ref="reviewForm">
                {this.state.formComponent}
            </div>
        )
    }
    componentDidMount() {
        let that = this
        $.get(rb.baseUrl + '/app/' + this.props.entity + '/view-model?id=' + this.props.id, function(res){
            let elements = res.data.elements
            const FORM = <div className="row">{elements.map((item) => {
                return detectViewElement(item)
            })}</div>
            that.setState({ formComponent: FORM }, function(){
                $('.invisible').removeClass('invisible')
                if (parent && parent.RbViewModal_Comp) {
                    parent.RbViewModal_Comp.hideLoading(true)
                }
                
                $(that.refs['reviewForm']).find('.type-NTEXT .form-control-plaintext').perfectScrollbar()
            })
        });
    }
}

const detectViewElement = function(item){
    item.onView = true
    item.viewMode = true
    return (<div className={'col-12 col-sm-' + (item.isFull ? 12 : 6)}>{detectElement(item)}</div>)
}

// -- Usage

let rb = rb || {}

// props = { entity, recordId }
rb.RbViewForm = function(props, target){
    return renderRbcomp(<RbViewForm {...props}  />, target || 'tab-rbview')
}

const RbViewPage = {
    _RbViewForm:  null,
    
    init(id, entity) {
        this.__id = id
        this.__entity = entity
        this._RbViewForm = rb.RbViewForm({ entity: entity[1], id: id })
        
        $('.J_edit').click(function(){
            rb.RbFormModal({ id: id, title: `编辑${entity[0]}`, entity: entity[1], icon: entity[2] })
        })
        
        let that = this
        
        $('.J_assign').click(function(){
            rb.AssignDialog({ entity: entity[1], ids: id })
        })
        $('.J_share').click(function(){
            rb.ShareDialog({ entity: entity[1], ids: id })
        })
    },
    
    initVTabs(config) {
        let rs = []
        $(config).each(function(){
            $('<li class="nav-item"><a class="nav-link" href="#tab-' + this[0] + '" data-toggle="tab">' + this[1] + '</a></li>').appendTo('.nav-tabs')
            $('<div class="tab-pane active" id="tab-' + this[0] + '"><div class="related-list rb-loading rb-loading-active"></div></div>').appendTo('.tab-content')
            rs.push(this[0])
        })
        let that = this
        $('.nav-tabs li>a').on('click', function(e) {
            e.preventDefault()
            let _this = $(this)
            _this.tab('show')
            
            let pane = $(_this.attr('href')).find('.related-list')
            if (pane.hasClass('rb-loading-active')) {
                if (~~_this.find('.badge').text() > 0) {
                    ReactDOM.render(<RbSpinner/>, pane[0])
                    that.loadRelatedList(pane, _this.attr('href').substr(5))
                } else {
                    ReactDOM.render(<div className="list-nodata"><span className="zmdi zmdi-info-outline"/><p>没有相关数据</p></div>, pane[0])
                    pane.removeClass('rb-loading-active')
                }
            }
        })
        
        $.get(rb.baseUrl + '/app/entity/related-counts?master=' + this.__id + '&relates=' + rs.join(','), function(res){
            for (let k in res.data) {
                if (~~res.data[k] > 0) {
                    let nav = $('.nav-tabs a[href="#tab-' + k + '"]')
                    $('<span class="badge badge-pill badge-primary">' + res.data[k] + '</span>').appendTo(nav)
                }
            }
        })
    },
    
    loadRelatedList(el, related, page) {
        page = page || 1
        $.get(rb.baseUrl + '/app/entity/related-list?master=' + this.__id + '&related=' + related + '&pageNo=' + page, function(res){
            el.removeClass('rb-loading-active')
            $(res.data.data).each(function(){
                let h = '#!/View/' + related + '/' + this[0]
                $('<div class="card"><div class="float-left"><a href="' + h + '" onclick="RbViewPage.clickView(this)">' + this[1] + '</a></div><div class="float-right" title="修改时间">' + this[2] + '</div><div class="clearfix"></div></div>').appendTo(el)
            })
        })
    },
    
    clickView(el) {
        console.log($(el).attr('href'))
    }
}