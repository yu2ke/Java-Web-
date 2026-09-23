package com.wyu.canteen.servlet;

import com.wyu.canteen.dao.MenuDao;
import com.wyu.canteen.dao.RecipeDao;
import com.wyu.canteen.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/** 菜单管理：新建菜单 / 改名 / 删除菜单 / 加菜 / 改价 / 删菜 / 切换当前菜单 */
@WebServlet("/menu/*")
public class MenuServlet extends HttpServlet {

    private final MenuDao menuDao = new MenuDao();
    private final RecipeDao recipeDao = new RecipeDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int currentId = menuDao.currentMenuId();
        String viewId = req.getParameter("menuId");
        int menuId = viewId != null ? RecipeServlet.parseInt(viewId, currentId) : currentId;
        req.setAttribute("menus", menuDao.listMenus());
        req.setAttribute("currentId", currentId);
        req.setAttribute("menuId", menuId);
        req.setAttribute("items", menuDao.items(menuId));
        req.setAttribute("recipes", recipeDao.list(null));
        req.getRequestDispatcher("/WEB-INF/views/menu/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        User user = (User) req.getSession().getAttribute("loginUser");
        String msg = null;
        switch (path) {
            case "/create":
                menuDao.create(req.getParameter("menuName"), user == null ? 1 : user.getUserId());
                break;
            case "/rename": {
                String name = req.getParameter("menuName");
                if (name == null || name.trim().isEmpty()) {
                    msg = "菜单名不能为空";
                } else {
                    menuDao.renameMenu(RecipeServlet.parseInt(req.getParameter("menuId"), 0), name.trim());
                    msg = "菜单已改名";
                }
                break;
            }
            case "/menuDelete": {
                int menuId = RecipeServlet.parseInt(req.getParameter("menuId"), 0);
                msg = menuDao.deleteMenu(menuId) > 0 ? "菜单已删除（该菜单的菜品一并删除，历史订单不受影响）"
                                                    : "删除失败，请刷新后重试";
                break;
            }
            case "/addItem":
                menuDao.addItemFromRecipe(RecipeServlet.parseInt(req.getParameter("menuId"), 0),
                                          RecipeServlet.parseInt(req.getParameter("recipeId"), 0));
                break;
            case "/itemPrice":
                menuDao.updateItemPrice(RecipeServlet.parseInt(req.getParameter("itemId"), 0),
                                        RecipeServlet.parseDouble(req.getParameter("price"), 0));
                break;
            case "/itemDelete":
                menuDao.deleteItem(RecipeServlet.parseInt(req.getParameter("itemId"), 0));
                break;
            case "/activate":
                menuDao.activate(RecipeServlet.parseInt(req.getParameter("menuId"), 0));
                break;
            default:
        }
        String suffix = msg == null ? "" : "?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/menu" + suffix);
    }
}
